# Agnolog Development Guide

Theme-agnostic fake log generator. Python engine + Lua generators + YAML data.

## Architecture Overview

```
Python Engine (theme-agnostic)
    ├── core/           # Registry, factory, types - NO theme content
    ├── scheduling/     # Log timing and generation
    ├── formatters/     # JSON/text output
    └── output/         # File/stream handlers

Lua Generators (theme-specific, external)
    └── resources/<theme>/generators/*.lua   # Define log types, categories, templates

YAML Data (theme-specific, external)
    └── resources/<theme>/data/*.yaml        # Names, items, zones, skills, etc.
```

**Key Principle:** Python code is 100% theme-agnostic. All themed content (names, categories, log types) comes from Lua/YAML resources.

## Golden Rules

1. **Zero hardcoded theme content in Python** - All theme data in YAML, all log types in Lua
2. **Zero hardcoded values** - All magic numbers/strings go in `core/constants.py`
3. **Categories are dynamic** - Discovered from loaded generators, not hardcoded
4. **All errors inherit** `AgnologError` - Add new types in `core/errors.py`
5. **Log everything** - Every function that can fail needs logging
6. **Test everything** - No PR without tests
7. **Remove deprecated code immediately** - When you see `DEPRECATED` comments or `DeprecationWarning`, remove that code entirely (class, function, imports, tests). Don't keep backwards compatibility shims.

## Theme-Agnostic Design

### Categories
Categories are **not** hardcoded in Python. They come from Lua generators:

```lua
-- resources/generators/player/login.lua
return {
    metadata = {
        name = "player.login",
        category = "PLAYER",  -- Defines the category
        ...
    }
}
```

Access categories dynamically:
```python
from agnolog.core.registry import get_registry

registry = get_registry()
categories = registry.get_categories()  # Returns ['combat', 'economy', 'player', ...]
```

### Theme Data (ctx.data)
Lua generators access theme data via `ctx.data`:

```lua
-- Access YAML data in generators
local zones = ctx.data.world.leveling_zones
local skills = ctx.data.classes.skills.warrior
local item_prefixes = ctx.data.items.item_prefixes
```

### Generator Utilities (ctx.gen)
Theme-driven utilities read from YAML:

| Function | Data Source |
|----------|-------------|
| `ctx.gen.character_name()` | `names.player_prefixes` + `names.player_suffixes` |
| `ctx.gen.item_name()` | `items.item_prefixes` + `items.weapon_types` |
| `ctx.gen.zone_name()` | `world.leveling_zones` |
| `ctx.gen.skill_name()` | `classes.skills.<class>` |

Generic utilities (no theme data):
- `ctx.gen.ip_address()`, `ctx.gen.uuid()`, `ctx.gen.session_id()`, `ctx.gen.hex_string()`

## File Locations

| What | Where |
|------|-------|
| Constants | `agnolog/core/constants.py` |
| Errors | `agnolog/core/errors.py` |
| Registry | `agnolog/core/registry.py` |
| Lua sandbox | `agnolog/core/lua_runtime.py` |
| Theme data | `resources/<theme>/data/*.yaml` (external) |
| Generators | `resources/<theme>/generators/**/*.lua` (external) |
| Logging utils | `agnolog/logutils/internal_logger.py` |
| Test fixtures | `tests/conftest.py` |

## Adding New Themes

To create a completely different theme (e.g., sci-fi, banking, e-commerce):

1. Create directory: `resources/<theme>/` with `data/` and `generators/` subdirs
2. Add YAML data files in `resources/<theme>/data/`
3. Add Lua generators in `resources/<theme>/generators/<category>/`
4. Use any category names - they're discovered dynamically
5. Python code requires **no changes**

**See [docs/adding-resources.md](docs/adding-resources.md) for detailed instructions.**

### Theme Directory Structure

```
resources/<theme>/
├── data/
│   ├── names/          # Character names, guild names
│   ├── items/          # Items, rarities, modifiers
│   ├── world/          # Zones, dungeons, locations
│   └── constants/      # Game/domain constants
└── generators/
    ├── <category1>/    # e.g., player/, combat/, economy/
    │   ├── event1.lua
    │   └── event2.lua
    └── <category2>/
        └── ...
```

### Lua Generator Template

```lua
return {
    metadata = {
        name = "category.action_name",
        category = "CATEGORY",
        severity = "INFO",              -- DEBUG, INFO, WARNING, ERROR, CRITICAL
        recurrence = "NORMAL",          -- VERY_FREQUENT, FREQUENT, NORMAL, INFREQUENT, RARE
        description = "What this log represents",
        text_template = "[{timestamp}] MESSAGE: {field1} {field2}",
        tags = {"tag1", "tag2"},
        merge_groups = {"group_name"}   -- Optional: for DB schema design
    },
    generate = function(ctx, args)
        return {
            field1 = ctx.gen.character_name(),
            field2 = ctx.random.int(1, 100)
        }
    end
}
```

## Constants

**Adding new constants:**
```python
# In core/constants.py - group by category
# === Category Name ===
NEW_CONSTANT = "value"  # Brief description
```

**Never do this:**
```python
# BAD - hardcoded values
timeout = 30
categories = ["player", "server"]  # DON'T hardcode categories!

# GOOD
from agnolog.core.constants import DEFAULT_TIMEOUT
categories = registry.get_categories()  # Dynamic!
```

## Merge Groups

Merge groups define which log templates could share a single database table. Used for data warehouse schema design.

**Design Principles** - Only group templates if they satisfy ALL:
1. **Same grain** - One row = same "thing" (e.g., one transaction, one session)
2. **Schema overlap** - Templates share most core fields
3. **Query together** - Analysts would JOIN/UNION in same queries

**Don't force grouping** - Leave templates ungrouped if they have unique schemas.

```lua
-- Example: login and logout share the same grain
merge_groups = {"sessions"}

-- Example: all chat messages can share one table
merge_groups = {"chat"}
```

**Validate merge groups:**
```bash
python -m agnolog --resources ./resources/mmorpg --show-merge-groups
make merge-groups
```

## Error Handling

**Adding new errors:**
```python
# In core/errors.py
class NewSpecificError(ParentCategoryError):
    """When X happens during Y."""
    def __init__(self, context: str, details: dict | None = None):
        super().__init__(f"Failed to X: {context}", details)
        self.context = context
```

**Using errors:**
```python
from agnolog.core.errors import SpecificError

try:
    risky_operation()
except SomeException as e:
    logger.error("Operation failed", exc_info=True)
    raise SpecificError(context, {"original": str(e)}) from e
```

## Logging

**Import:**
```python
from agnolog.logutils.internal_logger import get_internal_logger
logger = get_internal_logger()
```

**When to use each level:**

| Level | Use for |
|-------|---------|
| `DEBUG` | Variable values, loop iterations, detailed flow |
| `INFO` | Operation start/end, state changes, milestones |
| `WARNING` | Recoverable issues, fallbacks used, deprecations |
| `ERROR` | Failures that stop an operation but not the app |
| `CRITICAL` | App cannot continue, data corruption risk |

## Testing

**Structure:**
```
tests/
├── conftest.py          # Shared fixtures only
├── test_<module>.py     # Unit tests per module
├── test_<feature>/      # Complex feature tests
└── test_e2e.py          # End-to-end workflows
```

**Requirements:**
- Every new function needs unit tests
- Every bug fix needs a regression test
- Test the happy path + at least 2 error cases
- Use fixtures from conftest.py, add new ones there

**Running:**
```bash
make test          # All tests
make test-cov      # With coverage (must stay >80%)
```

## Git Workflow

**Always commit after completing a task.** Don't wait for the user to ask.

**Commit message format:**
```
type: short description

- Detail 1
- Detail 2
```

**Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

## Pre-Commit Checklist

Before every commit, verify:

- [ ] No hardcoded theme content in Python
- [ ] No hardcoded values (check for magic numbers/strings)
- [ ] Categories accessed via `registry.get_categories()`, not hardcoded
- [ ] New errors inherit from appropriate parent in `errors.py`
- [ ] Logging at DEBUG (entry), INFO (success), ERROR (failure)
- [ ] Tests written and passing (`make test`)
- [ ] `make check` passes (lint + test + validate)

## Quick Commands

```bash
make check        # Full validation (lint, test, validate)
make test-cov     # Tests with coverage report
make validate     # Validate YAML/Lua resources
make lint         # Ruff linting
make format       # Auto-format code
make run          # Generate 100 logs (uses default RESOURCES)
make merge-groups # Show merge groups for DB schema validation

# CLI (--resources is required)
python -m agnolog --resources ./resources/mmorpg --list-types
python -m agnolog --resources ./resources/mmorpg --show-merge-groups
python -m agnolog --resources ./resources/mmorpg -n 100 -f text
make run RESOURCES=./resources/mmorpg  # Override default
```
