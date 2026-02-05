return {
    metadata = {
        name = "system.bot_stopped",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Trading bot has stopped",
        text_template = "[{timestamp}] BOT_STOPPED: reason={reason} uptime={uptime} trades_executed={trades}",
        tags = {"system", "lifecycle", "shutdown"},
        merge_groups = {"bot_lifecycle"}
    },

    generate = function(ctx, args)
        local reasons = ctx.data.constants.stop_reasons or {"user_shutdown", "error", "maintenance"}

        local uptime_hours = ctx.random.int(1, 720)
        local uptime_str
        if uptime_hours < 24 then
            uptime_str = string.format("%dh", uptime_hours)
        else
            uptime_str = string.format("%dd%dh", math.floor(uptime_hours / 24), uptime_hours % 24)
        end

        return {
            reason = ctx.random.choice(reasons),
            uptime = uptime_str,
            trades = ctx.random.int(50, 5000)
        }
    end
}
