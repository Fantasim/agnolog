-- Economy Trade Cancel Generator

return {
    metadata = {
        name = "economy.trade_cancel",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Trade cancelled",
        text_template = "[{timestamp}] TRADE_CANCEL: {char_name} cancelled trade (reason: {reason})",
        tags = {"economy", "trade", "player"},
        merge_groups = {"player_trades"}
    },

    generate = function(ctx, args)
        local reasons = {"player_declined", "timeout", "distance", "combat",
            "inventory_full", "modified_offer"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            other_char = ctx.gen.character_name(),
            reason = ctx.random.choice(reasons)
        }
    end
}
