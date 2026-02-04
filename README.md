# Agnolog

Theme-agnostic fake log generator for benchmarking log parsers, testing pipelines, and ML training data.

## Installation

```bash
pip install agnolog
```

Or from source:

```bash
git clone https://github.com/yourname/agnolog.git
cd agnolog
pip install -e .
```

## Quick Start

```bash
# Generate 100 logs to stdout (JSON)
agnolog --resources ./resources/mmorpg -n 100

# Generate text logs to a file
agnolog --resources ./resources/mmorpg -n 1000 -f text -o server.log

# Generate loghub-compatible output (3 files)
agnolog --resources ./resources/mmorpg --loghub output -n 10000
```

## Output Formats

### JSON (default)

```bash
agnolog --resources ./resources/mmorpg -n 100
agnolog --resources ./resources/mmorpg -n 100 --pretty  # Pretty-printed
```

### Text

```bash
agnolog --resources ./resources/mmorpg -n 100 -f text
```

Output:
```
[2024-01-15 10:23:45] LOGIN: Shadowblade logged in from 192.168.1.100
[2024-01-15 10:23:47] CHAT: Firemage: Looking for group!
```

### Loghub Format

Generate benchmark-compatible output for log parsing research (matches [loghub](https://github.com/logpai/loghub) format):

```bash
agnolog --resources ./resources/mmorpg --loghub mydata -n 10000
```

Creates three files:

| File | Description |
|------|-------------|
| `mydata.log` | Raw text logs |
| `mydata_structured.csv` | CSV with LineId, Date, Day, Time, Component, Pid, Content, EventId, EventTemplate |
| `mydata_templates.csv` | Unique templates (EventId, EventTemplate) |

**Example structured CSV:**
```csv
LineId,Date,Day,Time,Component,Pid,Content,EventId,EventTemplate
1,Jan,15,10:23:45,Server,1000,"[2024-01-15 10:23:45] LOGIN: Shadowblade logged in",E1,"[<*>] LOGIN: <*> logged in"
```

## Understanding Duration and Count

Agnolog simulates realistic log timing. Logs are generated over a **time window** (duration) with realistic intervals between events.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `-n, --count` | 100 | Maximum number of logs to generate |
| `--duration` | 3600 | Time window in seconds (1 hour) |

**The generator stops when EITHER limit is reached.**

With default settings (~10 logs/second realistic rate):
- 1 hour duration = ~36,000 logs max
- For more logs, increase duration

### Examples

```bash
# 10,000 logs (fits in 1 hour)
agnolog --resources ./resources/mmorpg --loghub data -n 10000

# 100,000 logs (need ~3 hours)
agnolog --resources ./resources/mmorpg --loghub data -n 100000 --duration 10800

# 1,000,000 logs (need ~28 hours of simulated time)
agnolog --resources ./resources/mmorpg --loghub data -n 1000000 --duration 100800
```

**Quick formula:** `duration = count / 10` (approximate)

## Filtering

### By Category

```bash
agnolog --resources ./resources/mmorpg --categories player combat -n 100
```

### By Log Type

```bash
agnolog --resources ./resources/mmorpg --types player.login player.logout -n 100
```

### List Available Types

```bash
agnolog --resources ./resources/mmorpg --list-types
```

## CLI Reference

```
agnolog --resources PATH [options]

Required:
  --resources PATH       Path to resources directory (generators + data)

Output options:
  -n, --count N          Number of logs to generate (default: 100)
  -f, --format FORMAT    Output format: json, ndjson, text (default: json)
  -o, --output FILE      Output file (default: stdout)
  --pretty               Pretty-print JSON output
  --loghub PREFIX        Generate loghub format (PREFIX.log, PREFIX_structured.csv, PREFIX_templates.csv)

Filtering:
  --categories CAT ...   Filter by categories
  --types TYPE ...       Filter by specific log types

Time control:
  --duration SECONDS     Time window for generation (default: 3600)
  --start-time ISO       Start timestamp (default: now)

Other:
  --list-types           List all available log types
  --list-categories      List all categories
  --server-id ID         Server identifier for logs
  -q, --quiet            Suppress progress messages
  validate               Validate all resources
```

## Using with Make

```bash
make run           # Generate 100 JSON logs
make run-text      # Generate 100 text logs
make run-loghub    # Generate loghub format (1000 logs)
make list          # List available log types
make validate      # Validate resources
```

Override resources path:

```bash
make run RESOURCES=/path/to/my/resources
```

## Creating Custom Resources

See [docs/adding-resources.md](docs/adding-resources.md) for creating your own themes.

Resources structure:
```
resources/mytheme/
  generators/
    category1/
      event1.lua
      event2.lua
    category2/
      ...
  data/
    names.yaml
    items.yaml
    ...
```

## License

MIT
