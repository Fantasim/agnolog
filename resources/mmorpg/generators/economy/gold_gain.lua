-- Economy Gold Gain Generator
-- Generates gold gain log entries

return {
    metadata = {
        name = "economy.gold_gain",
        category = "ECONOMY",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Gold gained event",
        text_template = "[{timestamp}] GOLD+: {char_name} +{amount}g from {source}",
        tags = {"economy", "gold", "gain"},
        merge_groups = {"gold_flow"}
    },

    -- Gold sources with min/max amounts
    sources = {
        {name = "quest_reward", min = 50, max = 500},
        {name = "mob_loot", min = 1, max = 50},
        {name = "item_sale", min = 10, max = 1000},
        {name = "trade", min = 100, max = 10000},
        {name = "auction_sale", min = 500, max = 50000},
        {name = "daily_reward", min = 100, max = 200},
        {name = "achievement", min = 50, max = 500},
        {name = "guild_reward", min = 100, max = 1000}
    },

    generate = function(ctx, args)
        local self = ctx.data.generators and ctx.data.generators.economy and ctx.data.generators.economy.gold_gain or {}

        -- Use built-in sources if not overridden
        local sources = self.sources or {
            {name = "quest_reward", min = 50, max = 500},
            {name = "mob_loot", min = 1, max = 50},
            {name = "item_sale", min = 10, max = 1000},
            {name = "trade", min = 100, max = 10000}
        }

        -- Pick a source
        local source_data = ctx.random.choice(sources)
        local source_name = source_data.name or source_data
        local min_amount = source_data.min or 1
        local max_amount = source_data.max or 1000

        local amount = ctx.random.int(min_amount, max_amount)

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            amount = amount,
            source = source_name,
            new_balance = ctx.random.int(amount, 999999)
        }
    end
}
