return {
    metadata = {
        name = "account.api_key_rotated",
        category = "ACCOUNT",
        severity = "INFO",
        recurrence = "RARE",
        description = "API key has been rotated for security",
        text_template = "[{timestamp}] API_KEY_ROTATED: {exchange} old_key=***{old_suffix} new_key=***{new_suffix}",
        tags = {"account", "security", "api"},
        merge_groups = {"account_balance"}
    },

    generate = function(ctx, args)
        local exchanges = ctx.data.exchanges.exchanges or {"Binance", "Coinbase Pro"}

        return {
            exchange = ctx.random.choice(exchanges),
            old_suffix = ctx.gen.hex_string(8),
            new_suffix = ctx.gen.hex_string(8)
        }
    end
}
