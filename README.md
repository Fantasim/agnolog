# mmofakelog

A Python program that generates 100+ realistic MMORPG server log types with varied formats, smart recurrence patterns, and optional OpenAI integration for dynamic content.

## Features

- **104 log types** across 6 categories (Player, Server, Security, Economy, Combat, Technical)
- **Multiple output formats**: JSON and human-readable text
- **Realistic timing patterns**: Very frequent (packets) to rare (server restarts)
- **Optional AI integration**: OpenAI for dynamic chat messages and quest text
- **Extensible design**: Easy to add new log types via decorator registration

## Installation

```bash
pip install -e .
```

## Quick Start

```bash
# Generate 100 JSON logs to stdout
mmofakelog -n 100 -f json

# Generate text logs to file
mmofakelog -n 1000 -f text -o server.log

# List all available log types
mmofakelog --list-types

# Filter by category
mmofakelog --categories player combat

# Enable AI for dynamic content
mmofakelog -n 500 --ai
```

## Log Categories

| Category | Count | Examples |
|----------|-------|----------|
| Player | 25 | login, level_up, chat, quest_complete |
| Server | 15 | start, stop, cpu_usage, world_save |
| Security | 14 | login_failed, speed_hack, admin.ban |
| Economy | 15 | gold_gain, trade_complete, auction_buy |
| Combat | 20 | damage_dealt, boss_kill, pvp_death |
| Technical | 15 | connection_open, latency, database_query |

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
from mmofakelog.core.registry import register_log_type
from mmofakelog.core.types import LogCategory, LogSeverity, RecurrencePattern
from mmofakelog.generators.base import BaseLogGenerator

@register_log_type(
    name="player.custom_event",
    category=LogCategory.PLAYER,
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
usage: mmofakelog [-h] [-n COUNT] [-f {json,text}] [-o OUTPUT]
                  [--categories CATEGORIES] [--types TYPES]
                  [--exclude-types EXCLUDE] [--start-time TIME]
                  [--duration SECONDS] [--time-scale SCALE]
                  [--seed SEED] [--ai] [--pretty] [--quiet]
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
  --ai                Enable AI-generated content
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
pytest --cov=mmofakelog
```

## License

MIT
