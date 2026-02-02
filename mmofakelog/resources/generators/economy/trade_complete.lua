-- Economy Trade Complete Generator

return {
    metadata = {
        name = "economy.trade_complete",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Trade completed",
        text_template = "[{timestamp}] TRADE: {char1} <-> {char2}: {gold_exchanged}g, {items_exchanged} items",
        tags = {"economy", "trade", "player"}
    },

    generate = function(ctx, args)
        local char1 = args.char1 or ctx.gen.character_name()
        local char2 = args.char2 or ctx.gen.character_name()

        -- Generate items exchanged
        local char1_item_count = ctx.random.int(0, 5)
        local char2_item_count = ctx.random.int(0, 5)

        local char1_items = {}
        local char2_items = {}

        for i = 1, char1_item_count do
            table.insert(char1_items, ctx.gen.item_name())
        end
        for i = 1, char2_item_count do
            table.insert(char2_items, ctx.gen.item_name())
        end

        return {
            char1 = char1,
            char2 = char2,
            gold_exchanged = ctx.random.int(0, 10000),
            items_exchanged = char1_item_count + char2_item_count,
            char1_items = char1_items,
            char2_items = char2_items,
            char1_gold = ctx.random.int(0, 5000),
            char2_gold = ctx.random.int(0, 5000)
        }
    end
}
