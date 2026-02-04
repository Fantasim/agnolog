# agnolog

Theme-agnostic fake log generator. Python engine + Lua generators + YAML data.

## Features

- **100+ log types** - Fully configurable via Lua generators
- **Multiple output formats**: JSON and human-readable text
- **Realistic timing patterns**: Very frequent to rare events
- **Theme-agnostic**: Swap YAML/Lua files to generate any kind of logs
- **Extensible design**: Easy to add new log types via Lua or Python

## Installation

```bash
pip install -e .
```

## Quick Start

```bash
# Generate 100 JSON logs to stdout
agnolog -n 100 -f json

# Generate text logs to file
agnolog -n 1000 -f text -o server.log

# List all available log types
agnolog --list-types

# Filter by category
agnolog --categories player combat
```

## Log Categories

Categories are dynamic and defined in Lua generators. Default theme includes:

| Category | Examples |
|----------|----------|
| Player | login, level_up, chat, quest_complete |
| Server | start, stop, cpu_usage, world_save |
| Security | login_failed, speed_hack, admin.ban |
| Economy | gold_gain, trade_complete, auction_buy |
| Combat | damage_dealt, boss_kill, pvp_death |
| Technical | connection_open, latency, database_query |

## Output Formats

**JSON:**
```json
{"timestamp": "2024-01-15T12:30:45", "type": "player.login", "severity": "INFO", "username": "DragonSlayer", "ip": "192.168.1.100"}
```

**Text:**
```
[2024-01-15 12:30:45] LOGIN: DragonSlayer from 192.168.1.100 (region: NA-West)
```

## Adding New Log Types

```python
from agnolog.core.registry import register_log_type
from agnolog.core.types import LogSeverity, RecurrencePattern
from agnolog.generators.base import BaseLogGenerator

@register_log_type(
    name="player.custom_event",
    category="PLAYER",
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Custom player event",
    text_template="[{timestamp}] CUSTOM: {message}",
)
class CustomEventGenerator(BaseLogGenerator):
    def _generate_data(self, **kwargs):
        return {"message": "Something happened"}
```

## CLI Options

```
usage: agnolog [-h] [-n COUNT] [-f {json,text}] [-o OUTPUT]
               [--categories CATEGORIES] [--types TYPES]
               [--exclude-types EXCLUDE] [--start-time TIME]
               [--duration SECONDS] [--time-scale SCALE]
               [--seed SEED] [--pretty] [--quiet]
               [--list-types] [--version]

Options:
  -n, --count         Number of log entries to generate
  -f, --format        Output format (json or text)
  -o, --output        Output file path
  --categories        Filter by categories
  --types             Generate only specific log types
  --exclude-types     Exclude specific log types
  --start-time        Starting timestamp (ISO format)
  --duration          Duration in seconds
  --time-scale        Time scaling factor
  --seed              Random seed for reproducibility
  --pretty            Pretty-print JSON output
  --quiet             Suppress progress messages
  --list-types        List all available log types
```

## Development

```bash
# Install dev dependencies
pip install -e ".[dev]"

# Run tests
pytest

# Run tests with coverage
pytest --cov=agnolog
```

## License

MIT
