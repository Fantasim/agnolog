"""
Command-line interface for the MMORPG Fake Log Generator.

Usage:
    mmofakelog -n 100 -f json          # Generate 100 JSON logs
    mmofakelog -n 1000 -f text -o out.log  # Generate text logs to file
    mmofakelog --ai -n 500             # Use AI for chat messages
    mmofakelog --list-types            # List all available log types
"""

import argparse
import sys
from datetime import datetime, timedelta
from typing import List, Optional

from mmofakelog.core.config import Config
from mmofakelog.core.constants import DEFAULT_LOG_COUNT, DEFAULT_TIME_SCALE, VERSION
from mmofakelog.core.factory import LogFactory
from mmofakelog.core.registry import get_registry
from mmofakelog.core.types import LogCategory, LogFormat
from mmofakelog.formatters import JSONFormatter, TextFormatter
from mmofakelog.logging import setup_internal_logging, get_internal_logger
from mmofakelog.output import FileOutputHandler, StreamOutputHandler
from mmofakelog.scheduling import LogScheduler


def parse_categories(category_strs: Optional[List[str]]) -> Optional[List[LogCategory]]:
    """Parse category strings to LogCategory enums."""
    if not category_strs:
        return None

    categories = []
    category_map = {c.name.lower(): c for c in LogCategory}

    for cat_str in category_strs:
        cat_lower = cat_str.lower()
        if cat_lower in category_map:
            categories.append(category_map[cat_lower])

    return categories if categories else None


def list_types() -> None:
    """List all available log types."""
    # Import generators to register them
    from mmofakelog import generators  # noqa

    registry = get_registry()
    print(f"\nMMORPG Fake Log Generator v{VERSION}")
    print(f"{'=' * 50}")
    print(f"Total registered log types: {registry.count()}\n")

    # Group by category
    for category in LogCategory:
        types = registry.get_by_category(category)
        if types:
            print(f"\n{category.name} ({len(types)} types)")
            print("-" * 40)
            for log_type in sorted(types):
                meta = registry.get_metadata(log_type)
                if meta:
                    ai_marker = " [AI]" if meta.requires_ai else ""
                    print(f"  {log_type:<35} {meta.recurrence.name:<15}{ai_marker}")


def main(args: Optional[List[str]] = None) -> int:
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="Generate realistic MMORPG server logs",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  mmofakelog -n 100                    Generate 100 logs (JSON to stdout)
  mmofakelog -n 1000 -f text -o out.log  Generate text logs to file
  mmofakelog --ai -n 50                Use AI for chat messages
  mmofakelog --categories player combat  Filter to specific categories
  mmofakelog --list-types              List all available log types
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
        choices=["player", "server", "security", "economy", "combat", "technical"],
        help="Filter by categories",
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
        "--ai",
        action="store_true",
        help="Enable AI for dynamic content generation",
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
        "--seed",
        type=int,
        default=None,
        help="Random seed for reproducible output",
    )

    parsed = parser.parse_args(args)

    # Handle list-types early
    if parsed.list_types:
        list_types()
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

    # Import generators to register them
    from mmofakelog import generators  # noqa

    logger.info(f"Starting log generation: {parsed.count} logs")

    # Setup AI client if enabled
    ai_client = None
    if parsed.ai:
        try:
            from mmofakelog.ai import AIClient
            ai_client = AIClient()
            if ai_client.is_available:
                logger.info("AI content generation enabled")
            else:
                logger.warning("AI requested but not available (no API key?)")
        except Exception as e:
            logger.warning(f"Failed to initialize AI client: {e}")

    # Create factory and scheduler
    factory = LogFactory(ai_client=ai_client, server_id=parsed.server_id)
    scheduler = LogScheduler(factory, time_scale=parsed.time_scale)

    # Configure enabled log types
    categories = parse_categories(parsed.categories)
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
