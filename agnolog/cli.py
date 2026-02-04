"""
Command-line interface for the Agnolog Fake Log Generator.

Resources are external to the package and must be provided via --resources.

Usage:
    agnolog --resources /path/to/resources -n 100
    agnolog --resources ~/mygame/resources -f text -o out.log
    agnolog --resources ./resources --list-types
    agnolog --resources ./resources validate
"""

import argparse
import sys
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Optional

from agnolog.core.config import Config
from agnolog.core.constants import DEFAULT_LOG_COUNT, DEFAULT_TIME_SCALE, VERSION
from agnolog.core.factory import LogFactory
from agnolog.core.registry import get_registry, register_lua_generators
from agnolog.core.types import LogFormat
from agnolog.formatters import JSONFormatter, TextFormatter
from agnolog.logutils import setup_internal_logging, get_internal_logger
from agnolog.output import FileOutputHandler, StreamOutputHandler
from agnolog.scheduling import LogScheduler


def parse_categories(category_strs: Optional[List[str]]) -> Optional[List[str]]:
    """Parse category strings to uppercase category names."""
    if not category_strs:
        return None

    # Convert to uppercase (category strings are stored uppercase)
    categories = [cat.upper() for cat in category_strs]
    return categories if categories else None


def list_types(use_lua: bool = True, resources_path: Optional[str] = None) -> None:
    """List all available log types."""
    # Import Python generators to register them
    from agnolog import generators  # noqa

    # Load Lua generators if requested
    if use_lua:
        try:
            lua_count = register_lua_generators(resources_path)
        except Exception as e:
            print(f"Warning: Failed to load Lua generators: {e}", file=sys.stderr)
            lua_count = 0
    else:
        lua_count = 0

    registry = get_registry()
    print(f"\nMMORPG Fake Log Generator v{VERSION}")
    print(f"{'=' * 50}")
    print(f"Total registered log types: {registry.count()}")
    if use_lua and lua_count > 0:
        print(f"(including {lua_count} Lua generators)")
    print()

    # Group by category (dynamically discovered)
    for category in registry.get_categories():
        types = registry.get_by_category(category.upper())
        if types:
            print(f"\n{category.upper()} ({len(types)} types)")
            print("-" * 40)
            for log_type in sorted(types):
                meta = registry.get_metadata(log_type)
                if meta:
                    print(f"  {log_type:<35} {meta.recurrence.name:<15}")


def list_categories(use_lua: bool = True, resources_path: Optional[str] = None) -> None:
    """List all available categories."""
    # Import Python generators to register them
    from agnolog import generators  # noqa

    # Load Lua generators if requested
    if use_lua:
        try:
            register_lua_generators(resources_path)
        except Exception as e:
            print(f"Warning: Failed to load Lua generators: {e}", file=sys.stderr)

    registry = get_registry()
    summary = registry.categories_summary()

    print(f"\nAvailable Categories")
    print(f"{'=' * 40}")
    for category in sorted(summary.keys(), key=str.lower):
        print(f"  {category.lower():<20} ({summary[category]} log types)")
    print()


def validate_resources(resources_path: Optional[str] = None) -> int:
    """Validate all YAML and Lua resources."""
    from agnolog.core.resource_loader import ResourceLoader
    from agnolog.core.lua_runtime import LuaSandbox, LUPA_AVAILABLE

    print(f"\nMMORPG Fake Log Generator v{VERSION}")
    print(f"{'=' * 50}")
    print("Validating resources...\n")

    errors = []
    warnings = []

    # Validate YAML data files
    print("Checking YAML data files...")
    try:
        loader = ResourceLoader(resource_path=Path(resources_path) if resources_path else None)
        data = loader.load_all_nested()
        yaml_count = sum(len(v) if isinstance(v, dict) else 1 for v in data.values())
        print(f"  Loaded {yaml_count} data entries from {len(data)} categories")
    except Exception as e:
        errors.append(f"YAML loading error: {e}")
        print(f"  ERROR: {e}")

    # Validate Lua generators
    print("\nChecking Lua generators...")
    if not LUPA_AVAILABLE:
        warnings.append("Lua support not available (lupa not installed)")
        print("  WARNING: Lua support not available (install lupa)")
    else:
        try:
            sandbox = LuaSandbox(
                resource_loader=ResourceLoader(
                    resource_path=Path(resources_path) if resources_path else None
                )
            )
            metadata = sandbox.load_all_generators()
            print(f"  Loaded {len(metadata)} Lua generators")

            # Test each generator
            test_errors = 0
            for name in metadata:
                try:
                    sandbox.generate(name)
                except Exception as e:
                    test_errors += 1
                    errors.append(f"Generator {name}: {e}")

            if test_errors:
                print(f"  {test_errors} generators failed validation")
            else:
                print("  All generators passed validation")

        except Exception as e:
            errors.append(f"Lua loading error: {e}")
            print(f"  ERROR: {e}")

    # Summary
    print(f"\n{'=' * 50}")
    if errors:
        print(f"FAILED: {len(errors)} error(s) found")
        for err in errors:
            print(f"  - {err}")
        return 1
    elif warnings:
        print(f"PASSED with {len(warnings)} warning(s)")
        for warn in warnings:
            print(f"  - {warn}")
        return 0
    else:
        print("PASSED: All resources validated successfully")
        return 0


def main(args: Optional[List[str]] = None) -> int:
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="Generate realistic MMORPG server logs",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  agnolog --resources ./res -n 100                   Generate 100 logs (JSON to stdout)
  agnolog --resources ./res -n 1000 -f text -o out.log  Generate text logs to file
  agnolog --resources ./res --categories player combat  Filter to specific categories
  agnolog --resources ./res --list-types             List all available log types
  agnolog --resources ./res validate                 Validate all resources
        """,
    )

    parser.add_argument(
        "-v", "--version",
        action="version",
        version=f"mmofakelog {VERSION}",
    )

    parser.add_argument(
        "-n", "--count",
        type=int,
        default=DEFAULT_LOG_COUNT,
        help=f"Number of log entries to generate (default: {DEFAULT_LOG_COUNT})",
    )

    parser.add_argument(
        "-f", "--format",
        choices=["json", "text", "ndjson"],
        default="json",
        help="Output format (default: json)",
    )

    parser.add_argument(
        "-o", "--output",
        type=str,
        default=None,
        help="Output file (default: stdout)",
    )

    parser.add_argument(
        "--categories",
        type=str,
        nargs="+",
        help="Filter by categories (dynamically discovered from loaded generators)",
    )

    parser.add_argument(
        "--types",
        type=str,
        nargs="+",
        help="Specific log types to generate (e.g., player.login server.start)",
    )

    parser.add_argument(
        "--exclude-types",
        type=str,
        nargs="+",
        help="Log types to exclude",
    )

    parser.add_argument(
        "--start-time",
        type=str,
        default=None,
        help="Start time for logs (ISO format, default: now)",
    )

    parser.add_argument(
        "--duration",
        type=int,
        default=3600,
        help="Duration in seconds (default: 3600)",
    )

    parser.add_argument(
        "--time-scale",
        type=float,
        default=DEFAULT_TIME_SCALE,
        help="Time scale multiplier (default: 1.0)",
    )

    parser.add_argument(
        "--pretty",
        action="store_true",
        help="Pretty-print JSON output",
    )

    parser.add_argument(
        "--server-id",
        type=str,
        default=None,
        help="Server ID to include in logs",
    )

    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Verbose output (show internal logs)",
    )

    parser.add_argument(
        "--quiet",
        action="store_true",
        help="Suppress all non-log output",
    )

    parser.add_argument(
        "--list-types",
        action="store_true",
        help="List all available log types and exit",
    )

    parser.add_argument(
        "--list-categories",
        action="store_true",
        help="List all available categories and exit",
    )

    parser.add_argument(
        "--seed",
        type=int,
        default=None,
        help="Random seed for reproducible output",
    )

    parser.add_argument(
        "--resources",
        type=str,
        required=True,
        help="Path to resources directory (contains data/ and generators/ subdirectories)",
    )

    parser.add_argument(
        "--use-lua",
        action="store_true",
        default=True,
        help="Use Lua generators (default: enabled)",
    )

    parser.add_argument(
        "--use-python",
        action="store_true",
        help="Use only Python generators (disable Lua)",
    )

    # Subcommands
    parser.add_argument(
        "command",
        nargs="?",
        choices=["validate"],
        help="Subcommand to run (validate: check all resources)",
    )

    parsed = parser.parse_args(args)

    # Handle validate subcommand
    if parsed.command == "validate":
        return validate_resources(parsed.resources)

    # Determine whether to use Lua
    use_lua = parsed.use_lua and not parsed.use_python

    # Handle list-types early
    if parsed.list_types:
        list_types(use_lua=use_lua, resources_path=parsed.resources)
        return 0

    # Handle list-categories early
    if parsed.list_categories:
        list_categories(use_lua=use_lua, resources_path=parsed.resources)
        return 0

    # Set random seed if provided
    if parsed.seed is not None:
        import random
        random.seed(parsed.seed)

    # Setup internal logging
    log_level = "DEBUG" if parsed.verbose else "WARNING"
    setup_internal_logging(
        level=log_level,
        quiet=parsed.quiet,
    )
    logger = get_internal_logger()

    # Import Python generators to register them
    from agnolog import generators  # noqa

    # Load Lua generators if enabled
    if use_lua:
        try:
            lua_count = register_lua_generators(parsed.resources)
            logger.info(f"Loaded {lua_count} Lua generators")
        except Exception as e:
            logger.warning(f"Failed to load Lua generators: {e}")
            if not parsed.quiet:
                print(f"Warning: Failed to load Lua generators: {e}", file=sys.stderr)

    logger.info(f"Starting log generation: {parsed.count} logs")

    # Validate categories if specified
    registry = get_registry()
    available_categories = registry.get_categories()
    categories = parse_categories(parsed.categories)

    if categories:
        invalid_cats = [c.lower() for c in categories if c.lower() not in available_categories]
        if invalid_cats:
            print(f"Error: Unknown categories: {', '.join(invalid_cats)}", file=sys.stderr)
            print(f"Available categories: {', '.join(available_categories)}", file=sys.stderr)
            return 1

    # Create factory and scheduler
    factory = LogFactory(server_id=parsed.server_id)
    scheduler = LogScheduler(factory, time_scale=parsed.time_scale)
    scheduler.enable_log_types(
        log_types=parsed.types,
        categories=categories,
    )

    # Exclude types if specified
    if parsed.exclude_types:
        scheduler.disable_log_types(parsed.exclude_types)

    # Setup formatter
    if parsed.format == "json":
        formatter = JSONFormatter(pretty=parsed.pretty)
    elif parsed.format == "ndjson":
        formatter = JSONFormatter(pretty=False)
    else:
        formatter = TextFormatter()

    # Setup output handler
    if parsed.output:
        output_handler = FileOutputHandler(parsed.output)
        if not parsed.quiet:
            print(f"Writing to {parsed.output}...", file=sys.stderr)
    else:
        output_handler = StreamOutputHandler(add_newline=True)

    # Determine time range
    if parsed.start_time:
        try:
            start_time = datetime.fromisoformat(parsed.start_time)
        except ValueError:
            print(f"Error: Invalid start time format: {parsed.start_time}", file=sys.stderr)
            return 1
    else:
        start_time = datetime.now()

    end_time = start_time + timedelta(seconds=parsed.duration)

    # Generate logs
    try:
        count = 0
        for entry in scheduler.generate_range(start_time, end_time, max_logs=parsed.count):
            formatted = formatter.format(entry)
            output_handler.write(formatted)
            count += 1

        output_handler.close()

        if not parsed.quiet and parsed.output:
            print(f"Generated {count} log entries", file=sys.stderr)

        return 0

    except KeyboardInterrupt:
        if not parsed.quiet:
            print("\nInterrupted", file=sys.stderr)
        output_handler.close()
        return 130

    except Exception as e:
        logger.exception(f"Error during generation: {e}")
        if not parsed.quiet:
            print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
