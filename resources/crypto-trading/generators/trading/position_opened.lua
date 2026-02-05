return {
    metadata = {
        name = "trading.position_opened",
        category = "TRADING",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "New trading position opened",
        text_template = "[{timestamp}] POSITION_OPENED: {position_id} {side} {size} {pair} entry={entry_price} leverage={leverage}x",
        tags = {"position", "trading", "open"},
        merge_groups = {"positions"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}
        local sides = ctx.data.constants.position_sides or {"long", "short"}

        local pair = ctx.random.choice(pairs)
        local is_btc = string.find(pair, "BTC") ~= nil
        local entry_price = is_btc and ctx.random.float(40000, 70000) or ctx.random.float(1000, 4000)

        return {
            position_id = ctx.gen.uuid(),
            side = string.upper(ctx.random.choice(sides)),
            size = string.format("%.4f", ctx.random.float(0.01, 1)),
            pair = pair,
            entry_price = string.format("%.2f", entry_price),
            leverage = ctx.random.int(1, 20)
        }
    end
}
