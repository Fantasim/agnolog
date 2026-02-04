# mmofakelog Development Guide

Theme-agnostic fake log generator. Python engine + Lua generators + YAML data.

## Architecture Overview

```
Python Engine (theme-agnostic)
    ├── core/           # Registry, factory, types - NO theme content
    ├── scheduling/     # Log timing and generation
    ├── formatters/     # JSON/text output
    └── output/         # File/stream handlers

Lua Generators (theme-specific)
    └── resources/generators/*.lua   # Define log types, categories, templates

YAML Data (theme-specific)
    └── resources/data/*.yaml        # Names, items, zones, skills, etc.
```

**Key Principle:** Python code is 100% theme-agnostic. All themed content (names, categories, log types) comes from Lua/YAML resources.

## Golden Rules

1. **Zero hardcoded theme content in Python** - All theme data in YAML, all log types in Lua
2. **Zero hardcoded values** - All magic numbers/strings go in `core/constants.py`
3. **Categories are dynamic** - Discovered from loaded generators, not hardcoded
4. **All errors inherit** `MMOFakeLogError` - Add new types in `core/errors.py`
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
from mmofakelog.core.registry import get_registry

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
| Constants | `mmofakelog/core/constants.py` |
| Errors | `mmofakelog/core/errors.py` |
| Registry | `mmofakelog/core/registry.py` |
| Lua sandbox | `mmofakelog/core/lua_runtime.py` |
| Theme data | `mmofakelog/resources/data/*.yaml` |
| Generators | `mmofakelog/resources/generators/**/*.lua` |
| Logging utils | `mmofakelog/logutils/internal_logger.py` |
| Test fixtures | `tests/conftest.py` |

## Adding New Themes

To create a completely different theme (e.g., sci-fi, banking, e-commerce):

1. Create new YAML data files in `resources/data/`
2. Create Lua generators in `resources/generators/`
3. Use any category names you want - they're discovered dynamically
4. Python code requires **no changes**

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
from mmofakelog.core.constants import DEFAULT_TIMEOUT
categories = registry.get_categories()  # Dynamic!
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
from mmofakelog.core.errors import SpecificError

try:
    risky_operation()
except SomeException as e:
    logger.error("Operation failed", exc_info=True)
    raise SpecificError(context, {"original": str(e)}) from e
```

## Logging

**Import:**
```python
from mmofakelog.logutils.internal_logger import get_internal_logger
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
make check       # Full validation (lint, test, validate)
make test-cov    # Tests with coverage report
make validate    # Validate YAML/Lua resources
make lint        # Ruff linting
make format      # Auto-format code

# CLI
mmofakelog --list-categories    # Show available categories (dynamic)
mmofakelog --list-types         # Show all log types
mmofakelog -n 100 -f text       # Generate 100 text logs
```
