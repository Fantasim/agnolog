"""
Sandboxed Lua runtime for generator execution.

Provides a secure Lua execution environment with:
- Restricted access (no file I/O, no system calls)
- Injected Python utilities (random, data access)
- Generator loading and execution
"""

from __future__ import annotations

import logging
import random
import string
import uuid
from pathlib import Path
from typing import Any, Callable, Dict, List, Optional, Tuple

try:
    import lupa
    from lupa import LuaRuntime

    LUPA_AVAILABLE = True
except ImportError:
    LUPA_AVAILABLE = False
    LuaRuntime = None  # type: ignore

from agnolog.core.resource_loader import ResourceLoader

logger = logging.getLogger(__name__)


class LuaSandboxError(Exception):
    """Raised when Lua sandbox is violated or unavailable."""

    pass


class LuaGeneratorError(Exception):
    """Raised when a Lua generator fails."""

    pass


class LuaContext:
    """
    Context object passed to Lua generators.

    Provides safe access to:
    - Random utilities (ctx.random.*)
    - Data access (ctx.data.*)
    - Built-in generators (ctx.gen.*)
    """

    def __init__(self, data: Dict[str, Any]) -> None:
        """
        Initialize context with data.

        Args:
            data: All loaded YAML data as nested dict
        """
        self._data = data
        self._random = LuaRandomContext()
        self._gen = LuaGeneratorUtils(data)  # Pass data for theme-driven utilities

    @property
    def data(self) -> Dict[str, Any]:
        """Read-only access to all data."""
        return self._data

    @property
    def random(self) -> LuaRandomContext:
        """Random utilities."""
        return self._random

    @property
    def gen(self) -> LuaGeneratorUtils:
        """Built-in generators."""
        return self._gen


class LuaRandomContext:
    """Random utilities for Lua generators."""

    def choice(self, items: Any) -> Any:
        """
        Choose a random item from a list/table.

        Args:
            items: List, tuple, or Lua table

        Returns:
            Random item
        """
        if hasattr(items, "values"):
            # Lua table - convert to list
            items = list(items.values())
        elif hasattr(items, "__iter__") and not isinstance(items, (str, bytes)):
            items = list(items)
        else:
            return items

        if not items:
            return None
        return random.choice(items)

    def choices(self, items: Any, k: int = 1) -> List[Any]:
        """
        Choose k random items with replacement.

        Args:
            items: List or Lua table
            k: Number of items to choose

        Returns:
            List of random items
        """
        if hasattr(items, "values"):
            items = list(items.values())
        elif hasattr(items, "__iter__") and not isinstance(items, (str, bytes)):
            items = list(items)
        else:
            return [items] * k

        if not items:
            return []
        return random.choices(items, k=k)

    def int(self, min_val: int, max_val: int) -> int:
        """Random integer in [min_val, max_val]."""
        return random.randint(int(min_val), int(max_val))

    def float(self, min_val: float = 0.0, max_val: float = 1.0) -> float:
        """Random float in [min_val, max_val]."""
        return random.uniform(float(min_val), float(max_val))

    def gauss(self, mu: float, sigma: float) -> float:
        """Random value from Gaussian distribution."""
        return random.gauss(float(mu), float(sigma))

    def weighted_choice(self, items: Any, weights: Any) -> Any:
        """
        Choose item based on weights.

        Args:
            items: List of items
            weights: List of weights (same length as items)

        Returns:
            Randomly selected item
        """
        if hasattr(items, "values"):
            items = list(items.values())
        if hasattr(weights, "values"):
            weights = list(weights.values())

        if not items:
            return None
        return random.choices(items, weights=weights, k=1)[0]

    def shuffle(self, items: Any) -> List[Any]:
        """
        Return shuffled copy of items.

        Args:
            items: List to shuffle

        Returns:
            New shuffled list
        """
        if hasattr(items, "values"):
            items = list(items.values())
        else:
            items = list(items)
        result = items.copy()
        random.shuffle(result)
        return result

    def sample(self, items: Any, k: int) -> List[Any]:
        """
        Random sample without replacement.

        Args:
            items: Population to sample from
            k: Number of items

        Returns:
            List of k unique items
        """
        if hasattr(items, "values"):
            items = list(items.values())
        else:
            items = list(items)
        return random.sample(items, min(k, len(items)))


class LuaGeneratorUtils:
    """
    Generator utilities that read theme data from ctx.data.

    This class provides utilities for generating random values. Theme-specific
    data (names, items, zones, etc.) is read from YAML resources via the
    data parameter passed during initialization.

    The Python code remains theme-agnostic - all themed content comes from
    YAML/Lua resources.
    """

    def __init__(self, data: Optional[Dict[str, Any]] = None) -> None:
        """
        Initialize with data from YAML resources.

        Args:
            data: Nested dict of all loaded YAML data
        """
        self._data = data or {}

    def _get_data(self, *keys: str, default: Any = None) -> Any:
        """
        Safely navigate nested data structure.

        Args:
            *keys: Path of keys to traverse
            default: Default value if path not found

        Returns:
            Value at path or default
        """
        current = self._data
        for key in keys:
            if isinstance(current, dict) and key in current:
                current = current[key]
            else:
                return default
        return current

    def _require_data(self, *keys: str) -> Any:
        """
        Get data at path, raising error if not found.

        Args:
            *keys: Path of keys to traverse

        Returns:
            Value at path

        Raises:
            LuaGeneratorError: If path not found
        """
        value = self._get_data(*keys)
        if value is None:
            path = ".".join(keys)
            raise LuaGeneratorError(
                f"Required data not found: {path}. "
                f"Ensure the corresponding YAML file is loaded in resources/data/"
            )
        return value

    def ip_address(self, internal: bool = False) -> str:
        """Generate a random IP address."""
        if internal:
            prefix = random.choice(["192.168", "10.0", "172.16"])
            if prefix == "192.168":
                return f"192.168.{random.randint(0, 255)}.{random.randint(1, 254)}"
            elif prefix == "10.0":
                return f"10.{random.randint(0, 255)}.{random.randint(0, 255)}.{random.randint(1, 254)}"
            else:
                return f"172.{random.randint(16, 31)}.{random.randint(0, 255)}.{random.randint(1, 254)}"
        else:
            first = random.choice([
                random.randint(1, 9),
                random.randint(11, 126),
                random.randint(128, 191),
                random.randint(192, 223),
            ])
            return f"{first}.{random.randint(0, 255)}.{random.randint(0, 255)}.{random.randint(1, 254)}"

    def session_id(self, length: int = 16) -> str:
        """Generate a session ID."""
        chars = string.ascii_lowercase + string.digits
        random_part = "".join(random.choice(chars) for _ in range(length))
        return f"sess_{random_part}"

    def numeric_id(self, prefix: str = "", min_val: int = 100000000, max_val: int = 999999999) -> str:
        """Generate a numeric ID with optional prefix."""
        return f"{prefix}{random.randint(min_val, max_val)}"

    def uuid(self) -> str:
        """Generate a UUID."""
        return str(uuid.uuid4())

    def hex_string(self, length: int = 32) -> str:
        """Generate a random hex string."""
        return "".join(random.choice("0123456789abcdef") for _ in range(length))

    def random_string(self, length: int = 8, charset: str = None) -> str:
        """Generate a random string from the given charset."""
        if charset is None:
            charset = string.ascii_letters + string.digits
        return "".join(random.choice(charset) for _ in range(length))

    # ==========================================================================
    # Theme-driven utilities (read from ctx.data)
    # These functions maintain backward compatibility with existing Lua generators
    # but all data comes from YAML resources, not hardcoded Python values.
    # ==========================================================================

    def player_name(self) -> str:
        """Generate a random player username from loaded data."""
        # Try gamer-style names first (names.gamer_names.adjectives/nouns)
        gamer_names = self._get_data("names", "gamer_names", default={})
        adjectives = gamer_names.get("adjectives", []) if isinstance(gamer_names, dict) else []
        nouns = gamer_names.get("nouns", []) if isinstance(gamer_names, dict) else []

        if adjectives and nouns:
            pattern = random.choice(["adj_noun", "adj_noun_num"])
            if pattern == "adj_noun":
                return random.choice(adjectives) + random.choice(nouns)
            else:
                return random.choice(adjectives) + random.choice(nouns) + str(random.randint(1, 999))

        # Fall back to prefix+suffix style (names.player_prefixes/player_suffixes)
        prefixes = self._get_data("names", "player_prefixes", default=[])
        suffixes = self._get_data("names", "player_suffixes", default=[])

        if prefixes and suffixes:
            return random.choice(prefixes) + random.choice(suffixes)

        # Last resort: generate random string
        return f"User{random.randint(10000, 99999)}"

    def character_name(self) -> str:
        """Generate a character name from loaded data."""
        prefixes = self._get_data("names", "player_prefixes", default=[])
        suffixes = self._get_data("names", "player_suffixes", default=[])

        if prefixes and suffixes:
            return random.choice(prefixes) + random.choice(suffixes)

        # Try name_roots as fallback
        roots = self._get_data("names", "name_roots", default=[])
        if roots and suffixes:
            return random.choice(roots) + random.choice(suffixes)

        # Fallback
        return f"Char{random.randint(10000, 99999)}"

    def account_id(self) -> str:
        """Generate an account ID."""
        prefix = self._get_data("constants", "id_prefixes", "account", default="ACC")
        return f"{prefix}{random.randint(100000000, 999999999)}"

    def character_id(self) -> int:
        """Generate a character ID."""
        return random.randint(10000000, 99999999)

    def item_name(self) -> str:
        """Generate a random item name from loaded data."""
        prefix_data = self._get_data("items", "item_prefixes", default={})
        weapons = self._get_data("items", "weapon_types", default=[])
        armor = self._get_data("items", "armor_types", default=[])

        # Get prefix list (item_prefixes may be nested by rarity)
        prefixes = []
        if isinstance(prefix_data, dict):
            for prefix_list in prefix_data.values():
                if isinstance(prefix_list, list):
                    prefixes.extend(prefix_list)
        elif isinstance(prefix_data, list):
            prefixes = prefix_data

        # Get suffix list (item_suffixes may be nested by type)
        suffix_data = self._get_data("items", "item_suffixes", default={})
        suffixes = []
        if isinstance(suffix_data, dict):
            for suf_list in suffix_data.values():
                if isinstance(suf_list, list):
                    suffixes.extend(suf_list)
        elif isinstance(suffix_data, list):
            suffixes = suffix_data

        # Combine weapons and armor for base items
        base_items = weapons + armor if weapons or armor else []

        if prefixes and base_items and suffixes:
            return f"{random.choice(prefixes)} {random.choice(base_items)} {random.choice(suffixes)}"
        elif prefixes and base_items:
            return f"{random.choice(prefixes)} {random.choice(base_items)}"
        elif base_items:
            return random.choice(base_items)

        return f"Item_{random.randint(1000, 9999)}"

    def monster_name(self) -> str:
        """Generate a random monster name from loaded data."""
        monster_types = self._get_data("monsters", "monster_types", default={})

        if not isinstance(monster_types, dict):
            return f"Monster_{random.randint(100, 999)}"

        # Get available monster types
        types = monster_types.get("types", [])
        if not types:
            return f"Monster_{random.randint(100, 999)}"

        # Pick a random type
        monster_type = random.choice(types) if isinstance(types, list) else types

        # Get prefixes and names for this type
        prefixes_by_type = monster_types.get("prefixes", {})
        names_by_type = monster_types.get("names", {})

        prefix = ""
        name = monster_type

        if isinstance(prefixes_by_type, dict) and monster_type in prefixes_by_type:
            type_prefixes = prefixes_by_type[monster_type]
            if isinstance(type_prefixes, list) and type_prefixes:
                prefix = random.choice(type_prefixes)

        if isinstance(names_by_type, dict) and monster_type in names_by_type:
            type_names = names_by_type[monster_type]
            if isinstance(type_names, list) and type_names:
                name = random.choice(type_names)

        if prefix:
            return f"{prefix} {name}"
        return name

    def boss_name(self) -> str:
        """Generate a random boss name from loaded data."""
        # Try world bosses first
        world_bosses = self._get_data("monsters", "world_bosses", default=[])
        if world_bosses:
            return random.choice(world_bosses)

        # Try dungeon bosses (nested structure)
        dungeon_bosses = self._get_data("monsters", "dungeon_bosses", default={})
        if isinstance(dungeon_bosses, dict):
            all_bosses = []
            for bosses in dungeon_bosses.values():
                if isinstance(bosses, list):
                    all_bosses.extend(bosses)
            if all_bosses:
                return random.choice(all_bosses)

        return f"Boss_{random.randint(100, 999)}"

    def guild_name(self) -> str:
        """Generate a random guild name from loaded data."""
        guild_names = self._get_data("names", "guild_names", default={})
        prefixes = guild_names.get("prefixes", []) if isinstance(guild_names, dict) else []
        names = guild_names.get("names", []) if isinstance(guild_names, dict) else []

        if prefixes and names:
            return f"{random.choice(prefixes)} {random.choice(names)}"
        elif names:
            return random.choice(names)

        return f"Guild_{random.randint(100, 999)}"

    def zone_name(self) -> str:
        """Generate a random zone name from loaded data."""
        # Try leveling zones
        zones = self._get_data("world", "leveling_zones", default=[])
        if zones:
            return random.choice(zones)

        # Try starting zones
        starting = self._get_data("world", "starting_zones", default=[])
        if starting:
            return random.choice(starting)

        # Try cities
        cities = self._get_data("world", "cities", default=[])
        if cities:
            return random.choice(cities)

        return f"Zone_{random.randint(100, 999)}"

    def skill_name(self, char_class: str = None) -> str:
        """Generate a random skill name from loaded data."""
        # Skills are stored per class: classes.skills.<class_name>
        skills_data = self._get_data("classes", "skills", default={})

        if char_class and isinstance(skills_data, dict):
            # Normalize class name (lowercase, replace spaces)
            class_key = char_class.lower().replace(" ", "_")
            class_skills = skills_data.get(class_key, {})
            if isinstance(class_skills, dict):
                # Skills might be nested under 'abilities' or similar
                all_skills = []
                for skill_list in class_skills.values():
                    if isinstance(skill_list, list):
                        all_skills.extend(skill_list)
                if all_skills:
                    return random.choice(all_skills)

        # Get all skills across all classes
        all_skills = []
        if isinstance(skills_data, dict):
            for class_data in skills_data.values():
                if isinstance(class_data, dict):
                    for skill_list in class_data.values():
                        if isinstance(skill_list, list):
                            all_skills.extend(skill_list)
                elif isinstance(class_data, list):
                    all_skills.extend(class_data)

        if all_skills:
            return random.choice(all_skills)

        return f"Skill_{random.randint(100, 999)}"


class LuaSandbox:
    """
    Sandboxed Lua runtime for safe script execution.

    Provides:
    - Restricted Lua environment (no I/O, no system calls)
    - Injected context with safe Python utilities
    - Generator loading and execution
    """

    # Lua code to set up the sandbox environment
    SANDBOX_SETUP = """
    -- Remove dangerous globals
    io = nil
    os = {
        time = os.time,
        date = os.date,
        difftime = os.difftime,
        clock = os.clock
    }
    loadfile = nil
    dofile = nil
    debug = nil
    package = nil
    require = nil
    rawget = nil
    rawset = nil
    rawequal = nil
    collectgarbage = nil
    getfenv = nil
    setfenv = nil
    newproxy = nil

    -- Safe globals that remain: math, string, table, pairs, ipairs,
    -- next, type, tonumber, tostring, select, unpack, pcall, xpcall
    """

    def __init__(
        self,
        resource_loader: Optional[ResourceLoader] = None,
        timeout_ms: int = 5000,
    ) -> None:
        """
        Initialize the Lua sandbox.

        Args:
            resource_loader: ResourceLoader for data access
            timeout_ms: Execution timeout in milliseconds

        Raises:
            LuaSandboxError: If lupa is not available
        """
        if not LUPA_AVAILABLE:
            raise LuaSandboxError(
                "Lua support requires the 'lupa' package. "
                "Install it with: pip install lupa"
            )

        self._timeout_ms = timeout_ms
        self._resource_loader = resource_loader or ResourceLoader()
        self._lua: Optional[LuaRuntime] = None
        self._context: Optional[LuaContext] = None
        self._generators: Dict[str, Any] = {}
        self._initialized = False

    def initialize(self) -> None:
        """Initialize the Lua runtime and sandbox."""
        if self._initialized:
            return

        # Create Lua runtime
        self._lua = LuaRuntime(unpack_returned_tuples=True)

        # Apply sandbox restrictions
        self._lua.execute(self.SANDBOX_SETUP)

        # Load all data
        data = self._resource_loader.load_all_nested()

        # Create context
        self._context = LuaContext(data)

        # Inject Python context into Lua
        self._inject_context()

        self._initialized = True
        logger.debug("Lua sandbox initialized")

    def _inject_context(self) -> None:
        """Inject Python utilities into Lua globals."""
        if self._lua is None or self._context is None:
            return

        g = self._lua.globals()

        # Create ctx table
        ctx = self._lua.table()

        # Inject random utilities
        ctx["random"] = self._lua.table()
        ctx["random"]["choice"] = self._context.random.choice
        ctx["random"]["choices"] = self._context.random.choices
        ctx["random"]["int"] = self._context.random.int
        ctx["random"]["float"] = self._context.random.float
        ctx["random"]["gauss"] = self._context.random.gauss
        ctx["random"]["weighted_choice"] = self._context.random.weighted_choice
        ctx["random"]["shuffle"] = self._context.random.shuffle
        ctx["random"]["sample"] = self._context.random.sample

        # Inject generator utilities
        # Generic utilities (theme-agnostic)
        ctx["gen"] = self._lua.table()
        ctx["gen"]["ip_address"] = self._context.gen.ip_address
        ctx["gen"]["session_id"] = self._context.gen.session_id
        ctx["gen"]["numeric_id"] = self._context.gen.numeric_id
        ctx["gen"]["uuid"] = self._context.gen.uuid
        ctx["gen"]["hex_string"] = self._context.gen.hex_string
        ctx["gen"]["random_string"] = self._context.gen.random_string
        # Theme-driven utilities (read from ctx.data)
        ctx["gen"]["player_name"] = self._context.gen.player_name
        ctx["gen"]["character_name"] = self._context.gen.character_name
        ctx["gen"]["account_id"] = self._context.gen.account_id
        ctx["gen"]["character_id"] = self._context.gen.character_id
        ctx["gen"]["item_name"] = self._context.gen.item_name
        ctx["gen"]["monster_name"] = self._context.gen.monster_name
        ctx["gen"]["boss_name"] = self._context.gen.boss_name
        ctx["gen"]["guild_name"] = self._context.gen.guild_name
        ctx["gen"]["zone_name"] = self._context.gen.zone_name
        ctx["gen"]["skill_name"] = self._context.gen.skill_name

        # Inject data (convert Python dict to Lua table recursively)
        ctx["data"] = self._python_to_lua(self._context.data)

        g.ctx = ctx

    def _python_to_lua(self, obj: Any) -> Any:
        """
        Convert Python object to Lua-compatible type.

        Args:
            obj: Python object

        Returns:
            Lua-compatible object
        """
        if self._lua is None:
            return obj

        if isinstance(obj, dict):
            table = self._lua.table()
            for k, v in obj.items():
                table[k] = self._python_to_lua(v)
            return table
        elif isinstance(obj, (list, tuple)):
            table = self._lua.table()
            for i, v in enumerate(obj, 1):  # Lua tables are 1-indexed
                table[i] = self._python_to_lua(v)
            return table
        else:
            return obj

    def _lua_to_python(self, obj: Any) -> Any:
        """
        Convert Lua object to Python type.

        Args:
            obj: Lua object

        Returns:
            Python object
        """
        if LUPA_AVAILABLE and lupa.lua_type(obj) == "table":
            # Check if it's array-like or dict-like
            result = {}
            for k, v in obj.items():
                result[k] = self._lua_to_python(v)

            # If all keys are sequential integers starting from 1, convert to list
            if result and all(isinstance(k, int) for k in result.keys()):
                keys = sorted(result.keys())
                if keys == list(range(1, len(keys) + 1)):
                    return [result[k] for k in keys]
            return result
        else:
            return obj

    def load_generator(self, lua_file: Path) -> Tuple[str, Dict[str, Any]]:
        """
        Load a generator from a Lua file.

        Args:
            lua_file: Path to the Lua file

        Returns:
            Tuple of (generator_name, metadata_dict)

        Raises:
            LuaGeneratorError: If loading fails
        """
        self.initialize()

        if self._lua is None:
            raise LuaGeneratorError("Lua runtime not initialized")

        if not lua_file.exists():
            raise LuaGeneratorError(f"Generator file not found: {lua_file}")

        try:
            with open(lua_file, "r", encoding="utf-8") as f:
                lua_code = f.read()

            # Execute the Lua code to get the generator table
            generator = self._lua.execute(lua_code)

            if generator is None:
                raise LuaGeneratorError(f"Generator {lua_file} returned nil")

            # Extract metadata (use bracket notation for Lua tables)
            metadata = generator["metadata"]
            if metadata is None:
                raise LuaGeneratorError(f"Generator {lua_file} missing 'metadata'")

            name = metadata["name"]
            if name is None:
                raise LuaGeneratorError(f"Generator {lua_file} missing 'metadata.name'")

            # Verify generate function exists
            if generator["generate"] is None:
                raise LuaGeneratorError(f"Generator {lua_file} missing 'generate' function")

            # Store the generator
            self._generators[name] = generator

            # Convert metadata to Python dict
            metadata_dict = self._lua_to_python(metadata)

            logger.debug(f"Loaded Lua generator: {name}")
            return name, metadata_dict

        except lupa.LuaError as e:
            raise LuaGeneratorError(f"Lua error in {lua_file}: {e}")
        except Exception as e:
            raise LuaGeneratorError(f"Error loading {lua_file}: {e}")

    def load_all_generators(self, generators_path: Optional[Path] = None) -> Dict[str, Dict[str, Any]]:
        """
        Load all Lua generators from the generators directory.

        Args:
            generators_path: Path to generators directory

        Returns:
            Dict mapping generator names to their metadata
        """
        if generators_path is None:
            generators_path = self._resource_loader.resource_path / "generators"

        if not generators_path.exists():
            logger.warning(f"Generators path does not exist: {generators_path}")
            return {}

        all_metadata = {}

        for lua_file in generators_path.rglob("*.lua"):
            try:
                name, metadata = self.load_generator(lua_file)
                all_metadata[name] = metadata
            except LuaGeneratorError as e:
                logger.error(f"Failed to load {lua_file}: {e}")

        logger.info(f"Loaded {len(all_metadata)} Lua generators")
        return all_metadata

    def generate(self, name: str, **kwargs: Any) -> Dict[str, Any]:
        """
        Execute a generator and return the result.

        Args:
            name: Generator name (e.g., "player.login")
            **kwargs: Arguments to pass to the generator

        Returns:
            Generated data as Python dict

        Raises:
            LuaGeneratorError: If generation fails
        """
        self.initialize()

        if name not in self._generators:
            raise LuaGeneratorError(f"Unknown generator: {name}")

        if self._lua is None:
            raise LuaGeneratorError("Lua runtime not initialized")

        generator = self._generators[name]
        generate_fn = generator["generate"]

        if generate_fn is None:
            raise LuaGeneratorError(f"Generator {name} has no 'generate' function")

        try:
            # Convert kwargs to Lua table
            args = self._python_to_lua(kwargs)

            # Call the generate function
            result = generate_fn(self._lua.globals().ctx, args)

            # Convert result back to Python
            return self._lua_to_python(result)

        except lupa.LuaError as e:
            raise LuaGeneratorError(f"Lua error in {name}: {e}")
        except Exception as e:
            raise LuaGeneratorError(f"Error generating {name}: {e}")

    def get_metadata(self, name: str) -> Optional[Dict[str, Any]]:
        """
        Get metadata for a loaded generator.

        Args:
            name: Generator name

        Returns:
            Metadata dict or None if not found
        """
        if name not in self._generators:
            return None

        generator = self._generators[name]
        metadata = generator["metadata"]
        return self._lua_to_python(metadata) if metadata else None

    def list_generators(self) -> List[str]:
        """List all loaded generator names."""
        return list(self._generators.keys())

    def is_available(self) -> bool:
        """Check if Lua support is available."""
        return LUPA_AVAILABLE

    def reload(self) -> None:
        """Reload all resources and generators."""
        self._generators.clear()
        self._initialized = False
        self._resource_loader.reload()
        self.initialize()
