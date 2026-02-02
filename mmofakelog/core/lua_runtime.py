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

from mmofakelog.core.resource_loader import ResourceLoader

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
        self._gen = LuaGeneratorUtils()

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
    """Built-in generator utilities for common patterns."""

    # Name components (can be overridden by data)
    _name_prefixes = (
        "Aer", "Bal", "Cor", "Dra", "Eld", "Fae", "Gor", "Hel", "Ire", "Jax",
        "Kel", "Lor", "Mor", "Nyx", "Ori", "Pyr", "Quin", "Rav", "Sor", "Thal",
    )
    _name_suffixes = (
        "ion", "ius", "ara", "ora", "iel", "ael", "wen", "wyn", "mir", "dir",
        "las", "ras", "dor", "thor", "gar", "kar", "rin", "lin", "eth", "oth",
    )
    _gamer_adjectives = (
        "Epic", "Pro", "Elite", "Ultra", "Mega", "Super", "Hyper", "Neo",
        "Dark", "Shadow", "Silent", "Deadly", "Swift", "Fierce", "Savage",
    )
    _gamer_nouns = (
        "Slayer", "Killer", "Hunter", "Sniper", "Ninja", "Samurai", "Knight",
        "Warrior", "Mage", "Wizard", "Archer", "Assassin", "Reaper", "Demon",
    )

    def player_name(self) -> str:
        """Generate a random player username."""
        pattern = random.choice([
            "adjective_noun",
            "adjective_noun_num",
            "prefix_suffix",
        ])

        if pattern == "adjective_noun":
            return random.choice(self._gamer_adjectives) + random.choice(self._gamer_nouns)
        elif pattern == "adjective_noun_num":
            return (
                random.choice(self._gamer_adjectives)
                + random.choice(self._gamer_nouns)
                + str(random.randint(1, 999))
            )
        else:
            return random.choice(self._name_prefixes) + random.choice(self._name_suffixes)

    def character_name(self) -> str:
        """Generate a fantasy character name."""
        return random.choice(self._name_prefixes) + random.choice(self._name_suffixes)

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

    def account_id(self) -> str:
        """Generate an account ID."""
        return f"ACC{random.randint(100000000, 999999999)}"

    def character_id(self) -> int:
        """Generate a character ID."""
        return random.randint(10000000, 99999999)

    def uuid(self) -> str:
        """Generate a UUID."""
        return str(uuid.uuid4())

    def hex_string(self, length: int = 32) -> str:
        """Generate a random hex string."""
        return "".join(random.choice("0123456789abcdef") for _ in range(length))

    def item_name(self) -> str:
        """Generate a random item name."""
        prefixes = ("Gleaming", "Ancient", "Enchanted", "Mystic", "Shadow", "Blazing", "Frozen")
        items = ("Sword", "Staff", "Bow", "Dagger", "Shield", "Helm", "Ring", "Amulet")
        suffixes = ("of Power", "of the Eagle", "of Strength", "of Wisdom", "of Fortune")
        return f"{random.choice(prefixes)} {random.choice(items)} {random.choice(suffixes)}"

    def monster_name(self) -> str:
        """Generate a random monster name."""
        prefixes = ("Elder", "Ancient", "Dire", "Savage", "Cursed", "Corrupted", "Feral")
        types = ("Wolf", "Bear", "Spider", "Skeleton", "Ghoul", "Troll", "Ogre", "Elemental")
        return f"{random.choice(prefixes)} {random.choice(types)}"

    def boss_name(self) -> str:
        """Generate a random boss name."""
        titles = ("Lord", "King", "Queen", "Overlord", "Archon", "Warlord", "Matriarch")
        names = ("Ragnaros", "Onyxia", "Nefarian", "Hakkar", "Ossirian", "C'Thun", "Kel'Thuzad")
        return f"{random.choice(titles)} {random.choice(names)}"

    def guild_name(self) -> str:
        """Generate a random guild name."""
        prefixes = ("Order of", "Knights of", "The", "Ancient", "Brotherhood of", "Keepers of")
        names = ("Phoenix", "Dragon", "Shadow", "Light", "Storm", "Thunder", "Valor")
        return f"{random.choice(prefixes)} {random.choice(names)}"

    def zone_name(self) -> str:
        """Generate a random zone name."""
        zones = (
            "Elwynn Forest", "Westfall", "Duskwood", "Stranglethorn Vale",
            "Durotar", "The Barrens", "Ashenvale", "Felwood",
        )
        return random.choice(zones)

    def skill_name(self, char_class: str = None) -> str:
        """Generate a random skill name for a class."""
        skills = {
            "Warrior": ["Heroic Strike", "Execute", "Mortal Strike", "Shield Slam"],
            "Paladin": ["Holy Light", "Hammer of Justice", "Divine Shield", "Consecration"],
            "Priest": ["Flash Heal", "Shadow Word: Pain", "Power Word: Shield", "Mind Blast"],
            "Mage": ["Fireball", "Frostbolt", "Arcane Missiles", "Polymorph"],
            "Warlock": ["Shadow Bolt", "Corruption", "Fear", "Summon Demon"],
            "Shaman": ["Lightning Bolt", "Chain Lightning", "Healing Wave", "Earth Shock"],
            "Druid": ["Wrath", "Rejuvenation", "Moonfire", "Bear Form"],
            "Rogue": ["Sinister Strike", "Backstab", "Eviscerate", "Stealth"],
            "Hunter": ["Aimed Shot", "Multi-Shot", "Serpent Sting", "Feign Death"],
            "Monk": ["Tiger Palm", "Blackout Kick", "Spinning Crane Kick", "Touch of Death"],
        }
        if char_class and char_class in skills:
            return random.choice(skills[char_class])
        # Pick random class if not specified
        all_skills = [s for class_skills in skills.values() for s in class_skills]
        return random.choice(all_skills)


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
        ctx["gen"] = self._lua.table()
        ctx["gen"]["player_name"] = self._context.gen.player_name
        ctx["gen"]["character_name"] = self._context.gen.character_name
        ctx["gen"]["ip_address"] = self._context.gen.ip_address
        ctx["gen"]["session_id"] = self._context.gen.session_id
        ctx["gen"]["account_id"] = self._context.gen.account_id
        ctx["gen"]["character_id"] = self._context.gen.character_id
        ctx["gen"]["uuid"] = self._context.gen.uuid
        ctx["gen"]["hex_string"] = self._context.gen.hex_string
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
