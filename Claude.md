# mmofakelog Development Guide

MMORPG fake log generator. Lua generators + YAML data + Python core.

## Golden Rules

1. **Zero hardcoded values** - All magic numbers/strings go in `core/constants.py`
2. **All errors inherit** `MMOFakeLogError` - Add new types in `core/errors.py`
3. **Log everything** - Every function that can fail needs logging
4. **Test everything** - No PR without tests
5. **Commit often** - Small, atomic commits with clear messages
6. **Docs stay current** - Update docs in the same commit as code changes

## File Locations

| What | Where |
|------|-------|
| Constants | `mmofakelog/core/constants.py` |
| Errors | `mmofakelog/core/errors.py` |
| Logging utils | `mmofakelog/logutils/internal_logger.py` |
| Test fixtures | `tests/conftest.py` |
| Resource docs | `docs/adding-resources.md` |

## Constants

**Adding new constants:**
```python
# In core/constants.py - group by category
# === Category Name ===
NEW_CONSTANT = "value"  # Brief description
```

**Never do this:**
```python
# BAD
timeout = 30
if retries > 3:

# GOOD
from mmofakelog.core.constants import DEFAULT_TIMEOUT, MAX_RETRIES
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

**Required logging points:**
- Function entry with key params: `logger.debug(f"Processing {item_id}")`
- Success paths: `logger.info(f"Loaded {count} items")`
- Failure paths: `logger.error(f"Failed to load: {reason}", exc_info=True)`
- Performance concerns: `logger.warning(f"Slow query: {elapsed}ms")`

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

## Documentation

**Update in same commit:**
- New feature → Update README.md usage section
- New generator/resource → Update docs/adding-resources.md
- API change → Update affected docstrings
- New constant/error → Add inline comment

**Docstring format:**
```python
def function(param: str) -> Result:
    """One-line summary.

    Args:
        param: What it is.

    Returns:
        What comes back.

    Raises:
        SpecificError: When X fails.
    """
```

## Git Workflow

**Commit frequency:**
- After each logical change (don't batch unrelated changes)
- Before any risky operation
- When tests pass for a feature

**Commit message format:**
```
type: short description

- Detail 1
- Detail 2
```

**Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

**Branch naming:** `type/short-description` (e.g., `feat/new-generator`)

## Pre-Commit Checklist

Before every commit, verify:

- [ ] No hardcoded values (check for magic numbers/strings)
- [ ] New errors inherit from appropriate parent in `errors.py`
- [ ] Logging at DEBUG (entry), INFO (success), ERROR (failure)
- [ ] Tests written and passing (`make test`)
- [ ] Docs updated if user-facing change
- [ ] `make check` passes (lint + test + validate)

## Quick Commands

```bash
make check       # Full validation (lint, test, validate)
make test-cov    # Tests with coverage report
make validate    # Validate YAML/Lua resources
make lint        # Ruff linting
make format      # Auto-format code
```
