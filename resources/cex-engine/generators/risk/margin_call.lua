-- Margin Call Generator
-- Generates log entries when a margin call is issued to a user

return {
    metadata = {
        name = "risk.margin_call",
        category = "RISK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Margin call issued to user",
        text_template = "[{timestamp}] MARGIN_CALL: user={user_id} margin_ratio={margin_ratio}% required={required_margin} shortfall={shortfall}",
        tags = {"risk", "margin", "warning"},
        merge_groups = {"risk_events"}
    },

    generate = function(ctx, args)
        local margin_ratio = ctx.random.float(5, 15)
        local required_margin = ctx.random.float(10000, 100000)
        local current_margin = required_margin * (margin_ratio / 100)
        local shortfall = required_margin - current_margin

        return {
            user_id = "user_" .. ctx.random.int(10000, 99999),
            margin_ratio = string.format("%.2f", margin_ratio),
            current_margin = string.format("%.2f", current_margin),
            required_margin = string.format("%.2f", required_margin),
            shortfall = string.format("%.2f", shortfall),
            deadline_seconds = ctx.random.int(300, 3600),
            symbols_affected = ctx.random.int(1, 5)
        }
    end
}
