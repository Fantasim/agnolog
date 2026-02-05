-- Position Check Generator
-- Generates log entries for real-time position and exposure checks

return {
    metadata = {
        name = "risk.position_check",
        category = "RISK",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Real-time position and exposure check",
        text_template = "[{timestamp}] RISK_CHECK: user={user_id} position={position_size} exposure={exposure_usd} margin_ratio={margin_ratio} status={status}",
        tags = {"risk", "position", "exposure"},
        merge_groups = {"risk_events"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local position_size = ctx.random.float(-100, 100)
        local avg_price = ctx.random.float(30000, 60000)
        local mark_price = avg_price * ctx.random.float(0.95, 1.05)
        local exposure = math.abs(position_size * mark_price)
        local margin = exposure * ctx.random.float(0.1, 0.5)
        local margin_ratio = (margin / exposure) * 100

        local status = "HEALTHY"
        if margin_ratio < 25 then
            status = "WARNING"
        elseif margin_ratio < 10 then
            status = "CRITICAL"
        end

        return {
            user_id = "user_" .. ctx.random.int(10000, 99999),
            symbol = pair.symbol or "BTC/USDT",
            position_size = string.format("%.5f", position_size),
            exposure_usd = string.format("%.2f", exposure),
            margin_ratio = string.format("%.2f", margin_ratio),
            status = status,
            account_tier = ctx.random.choice({"RETAIL", "PROFESSIONAL"})
        }
    end
}
