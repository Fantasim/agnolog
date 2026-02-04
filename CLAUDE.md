# Claude Instructions

## Commit Policy

**Always commit after completing a task or set of related changes.** Don't wait for the user to ask.

- Commit immediately after finishing implementation work
- Use conventional commit format: `type: description`
  - `feat:` new feature
  - `fix:` bug fix
  - `refactor:` code restructuring
  - `docs:` documentation
  - `test:` test changes
  - `chore:` maintenance tasks

## Project Structure

- `agnolog/` - Main package (Python engine)
- `resources/` - External resources (not bundled with package)
  - `mmorpg/` - MMORPG theme resources
    - `data/` - YAML data files
    - `generators/` - Lua generators
- `tests/` - Test suite

## CLI Usage

Resources are external and must be specified:
```bash
python -m agnolog --resources ./resources/mmorpg -n 100
make run  # Uses default RESOURCES=./resources/mmorpg
```

## Running Tests

```bash
make test        # Run all tests
make test-quick  # Quick test run
make check       # Lint + test + validate
```
