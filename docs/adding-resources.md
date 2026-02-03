# Adding New Resources

This guide explains how to add new log types and data to mmofakelog using the resource system.

## Overview

mmofakelog uses a data-driven architecture:
- **YAML files** for static data (names, items, zones, constants)
- **Lua scripts** for log generators (the logic that creates log entries)

```
mmofakelog/resources/
├── data/           # YAML data files
│   ├── names/      # Player names, guild names, NPCs
│   ├── items/      # Weapons, armor, consumables
│   ├── world/      # Zones, dungeons, raids
│   ├── classes/    # Classes, races, skills
│   ├── monsters/   # Monster types, bosses
│   ├── quests/     # Quest types, story quests
│   └── constants/  # Game constants (combat, economy, etc.)
└── generators/     # Lua generator scripts
    ├── player/     # Player events (login, logout, chat, etc.)
    ├── combat/     # Combat events (damage, kills, dungeons)
    ├── economy/    # Economy events (trades, auctions, gold)
    ├── server/     # Server events (start, stop, metrics)
    ├── security/   # Security events (bans, hacks, audits)
    └── technical/  # Technical events (connections, errors)
```

## Adding a New Data File (YAML)

### Step 1: Choose the Right Location

Place your YAML file in the appropriate category under `resources/data/`:

| Category | Use For |
|----------|---------|
| `names/` | Character names, guild names, NPC names |
| `items/` | Item types, rarities, modifiers |
| `world/` | Zones, dungeons, cities, battlegrounds |
| `classes/` | Classes, races, skills |
| `monsters/` | Monster types, boss names |
| `quests/` | Quest types, objectives |
| `constants/` | Game constants, limits, rates |

### Step 2: Create the YAML File

Every YAML file should follow this structure:

```yaml
version: "1.0"
metadata:
  description: "Brief description of what this data contains"

data:
  # Your data here - can be a list or object
```

### Example: Adding Custom Currencies

Create `resources/data/constants/currencies.yaml`:

```yaml
version: "1.0"
metadata:
  description: "In-game currency definitions"

data:
  - id: gold
    name: Gold
    symbol: "g"
    max_stack: 9999999

  - id: silver
    name: Silver
    symbol: "s"
    max_stack: 99
    converts_to: gold
    conversion_rate: 100

  - id: copper
    name: Copper
    symbol: "c"
    max_stack: 99
    converts_to: silver
    conversion_rate: 100

  - id: arena_points
    name: Arena Points
    symbol: "AP"
    max_stack: 10000
    weekly_cap: 5000
```

### Example: Adding Custom Zones

Create `resources/data/world/custom_zones.yaml`:

```yaml
version: "1.0"
metadata:
  description: "Custom expansion zones"

data:
  - name: "Shadowmoon Valley"
    level_range: [67, 70]
    type: outdoor
    faction: contested

  - name: "Netherstorm"
    level_range: [67, 70]
    type: outdoor
    faction: contested
```

### Accessing Data in Lua

Once added, data is automatically available in generators via `ctx.data`:

```lua
-- Access nested data
local currencies = ctx.data.constants.currencies.data
local zones = ctx.data.world.custom_zones.data

-- Use with random choice
local zone = ctx.random.choice(zones)
local currency = ctx.random.choice(currencies)
```

## Adding a New Generator (Lua)

### Step 1: Choose the Category

Generators are organized by category:

| Category | Log Types |
|----------|-----------|
| `player/` | Login, logout, chat, achievements, inventory |
| `combat/` | Damage, healing, kills, dungeons, PvP |
| `economy/` | Trading, auctions, gold transactions |
| `server/` | Server start/stop, metrics, maintenance |
| `security/` | Login failures, bans, hack detection |
| `technical/` | Connections, errors, database queries |

### Step 2: Create the Lua File

Create a new `.lua` file in the appropriate category directory.

**File naming convention:** `action_name.lua` (lowercase, underscores)

Examples:
- `player/mount_summon.lua`
- `economy/trade_complete.lua`
- `combat/boss_kill.lua`

### Step 3: Write the Generator

Every generator must return a table with `metadata` and `generate`:

```lua
-- Description comment
-- Explains what this generator does

return {
    metadata = {
        name = "category.action_name",      -- Required: unique log type name
        category = "CATEGORY",               -- Required: PLAYER, COMBAT, ECONOMY, SERVER, SECURITY, TECHNICAL
        severity = "INFO",                   -- Required: DEBUG, INFO, WARNING, ERROR, CRITICAL
        recurrence = "NORMAL",               -- Required: VERY_FREQUENT, FREQUENT, NORMAL, INFREQUENT, RARE
        description = "What this log represents",
        text_template = "[{timestamp}] MESSAGE: {field1} {field2}",
        tags = {"tag1", "tag2"}              -- Optional: for filtering
    },

    generate = function(ctx, args)
        -- Generate and return log data
        return {
            field1 = "value1",
            field2 = ctx.random.int(1, 100)
        }
    end
}
```

### The Context Object (`ctx`)

The `ctx` parameter provides utilities for generating data:

#### Random Utilities (`ctx.random`)

```lua
ctx.random.int(min, max)        -- Random integer in range [min, max]
ctx.random.float(min, max)      -- Random float in range [min, max]
ctx.random.choice(list)         -- Random element from list
ctx.random.weighted(items, weights)  -- Weighted random choice
ctx.random.chance(probability)  -- Returns true with given probability (0.0-1.0)
ctx.random.gauss(mean, stddev)  -- Gaussian distribution
```

#### Built-in Generators (`ctx.gen`)

```lua
ctx.gen.player_name()       -- "DragonSlayer", "xXNightmareXx"
ctx.gen.character_name()    -- "Aerthys", "Thornwick"
ctx.gen.guild_name()        -- "Knights of the Eternal Flame"
ctx.gen.ip_address()        -- "192.168.1.100"
ctx.gen.session_id()        -- "sess_a1b2c3d4e5"
ctx.gen.uuid()              -- "550e8400-e29b-41d4-a716-446655440000"
ctx.gen.item_name()         -- "Blazing Sword of the Phoenix"
ctx.gen.zone_name()         -- "Elwynn Forest"
ctx.gen.npc_name()          -- "Guard Thomas"
```

#### Data Access (`ctx.data`)

Access any YAML data file:

```lua
-- File: resources/data/items/rarities.yaml
local rarities = ctx.data.items.rarities.data

-- File: resources/data/constants/combat.yaml
local combat = ctx.data.constants.combat

-- File: resources/data/world/dungeons.yaml
local dungeons = ctx.data.world.dungeons.data
```

### Complete Example: Bank Transaction Generator

Create `resources/generators/economy/bank_deposit.lua`:

```lua
-- Bank Deposit Generator
-- Generates log entries for player bank deposits

return {
    metadata = {
        name = "economy.bank_deposit",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player deposits items or gold into bank",
        text_template = "[{timestamp}] BANK: {player} deposited {amount}g and {item_count} items",
        tags = {"economy", "bank", "storage"}
    },

    generate = function(ctx, args)
        -- Get player info
        local player = args.player or ctx.gen.character_name()

        -- Random gold amount (weighted towards smaller amounts)
        local gold = 0
        if ctx.random.chance(0.7) then
            gold = ctx.random.int(1, 100)
        else
            gold = ctx.random.int(100, 5000)
        end

        -- Random number of items
        local item_count = ctx.random.int(0, 20)

        -- Generate item list if depositing items
        local items = {}
        for i = 1, math.min(item_count, 5) do
            table.insert(items, {
                name = ctx.gen.item_name(),
                quantity = ctx.random.int(1, 20)
            })
        end

        return {
            player = player,
            amount = gold,
            item_count = item_count,
            items = items,
            bank_slot = ctx.random.int(1, 98),
            bank_tab = ctx.random.int(1, 7)
        }
    end
}
```

### Complete Example: Custom Category (Finance)

You can use custom categories beyond the defaults. Create `resources/generators/finance/transaction.lua`:

```lua
-- Financial Transaction Generator
-- For non-MMO financial log simulation

return {
    metadata = {
        name = "finance.transaction",
        category = "FINANCE",           -- Custom category!
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Financial transaction record",
        text_template = "[{timestamp}] TXN: {transaction_id} {type} ${amount} from {account}",
        tags = {"finance", "transaction", "audit"}
    },

    generate = function(ctx, args)
        local transaction_types = {"DEPOSIT", "WITHDRAWAL", "TRANSFER", "PAYMENT", "REFUND"}
        local account_types = {"CHECKING", "SAVINGS", "CREDIT", "INVESTMENT"}

        return {
            transaction_id = ctx.gen.uuid(),
            type = ctx.random.choice(transaction_types),
            amount = ctx.random.float(10.00, 10000.00),
            account = string.format("%s-%s",
                ctx.random.choice(account_types),
                ctx.random.int(100000, 999999)
            ),
            currency = "USD",
            status = ctx.random.weighted(
                {"COMPLETED", "PENDING", "FAILED"},
                {0.85, 0.10, 0.05}
            ),
            timestamp_ms = os.time() * 1000
        }
    end
}
```

## Recurrence Patterns

The `recurrence` field controls how often the log type appears when using the scheduler:

| Pattern | Events per Hour | Use For |
|---------|-----------------|---------|
| `VERY_FREQUENT` | ~200+ | Packet sends, tick events |
| `FREQUENT` | ~50-100 | Combat damage, chat messages |
| `NORMAL` | ~10-30 | Logins, trades, quest completions |
| `INFREQUENT` | ~1-5 | Level ups, achievements |
| `RARE` | < 1 | Server restarts, bans, epic drops |

## Severity Levels

| Level | Use For |
|-------|---------|
| `DEBUG` | Low-level technical info (packets, queries) |
| `INFO` | Normal events (logins, trades, kills) |
| `WARNING` | Suspicious but not critical (failed logins) |
| `ERROR` | Errors that need attention (database errors) |
| `CRITICAL` | Severe issues (server crash, security breach) |

## Validating Your Resources

After adding new resources, validate them:

```bash
# Validate all resources
make validate

# Or directly:
python -m mmofakelog validate
```

This checks:
- YAML syntax is valid
- Lua scripts load without errors
- Generators produce valid output

## Testing Your Generator

Generate logs with your new type:

```bash
# Generate and filter to your type
python -m mmofakelog -n 10 --types economy.bank_deposit

# List all types to verify registration
python -m mmofakelog --list-types | grep bank
```

## Tips and Best Practices

### Data Files

1. **Keep files focused**: One concept per file (e.g., `weapon_types.yaml`, not `all_items.yaml`)
2. **Use descriptive IDs**: `legendary` not `r6`
3. **Include metadata**: Always add `version` and `description`
4. **Use consistent structure**: Follow existing file patterns

### Generators

1. **Handle missing data gracefully**: Always provide fallbacks
   ```lua
   local zones = ctx.data.world.zones or {}
   if #zones == 0 then
       zones = {"Default Zone"}
   end
   ```

2. **Use appropriate recurrence**: Don't make rare events frequent

3. **Match text_template to fields**: Ensure all `{field}` placeholders have corresponding return values

4. **Use built-in generators**: Prefer `ctx.gen.player_name()` over hardcoded names

5. **Add useful tags**: Help with filtering and categorization

## Directory Structure Reference

```
resources/
├── data/
│   ├── classes/
│   │   ├── classes.yaml          # Class definitions
│   │   ├── races.yaml            # Race definitions
│   │   └── skills/               # Per-class skill lists
│   │       ├── warrior.yaml
│   │       ├── mage.yaml
│   │       └── ...
│   ├── constants/
│   │   ├── combat.yaml           # Combat formulas, damage types
│   │   ├── economy.yaml          # Gold limits, tax rates
│   │   ├── network.yaml          # Packet types, ports
│   │   ├── server.yaml           # Server limits, regions
│   │   └── error_codes.yaml      # Error code definitions
│   ├── items/
│   │   ├── weapon_types.yaml
│   │   ├── armor_types.yaml
│   │   ├── consumables.yaml
│   │   ├── rarities.yaml
│   │   └── item_*.yaml           # Prefixes, suffixes, names
│   ├── monsters/
│   │   ├── monster_types.yaml
│   │   ├── dungeon_bosses.yaml
│   │   ├── raid_bosses.yaml
│   │   └── world_bosses.yaml
│   ├── names/
│   │   ├── player_*.yaml         # Name generation parts
│   │   ├── guild_names.yaml
│   │   ├── npc_names.yaml
│   │   └── chat_messages.yaml
│   ├── quests/
│   │   ├── quest_types.yaml
│   │   └── story_quests.yaml
│   └── world/
│       ├── starting_zones.yaml
│       ├── leveling_zones.yaml
│       ├── cities.yaml
│       ├── dungeons.yaml
│       ├── raids.yaml
│       └── battlegrounds.yaml
└── generators/
    ├── combat/                   # 20 generators
    ├── economy/                  # 15 generators
    ├── player/                   # 25 generators
    ├── security/                 # 14 generators
    ├── server/                   # 15 generators
    └── technical/                # 15 generators
```
