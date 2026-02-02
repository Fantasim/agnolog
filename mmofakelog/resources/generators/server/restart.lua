-- Server Restart Generator

return {
    metadata = {
        name = "server.restart",
        category = "SERVER",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Server restart",
        text_template = "[{timestamp}] SERVER_RESTART: {server_id} restarting (countdown: {countdown}s)",
        tags = {"server", "lifecycle", "restart"}
    },

    generate = function(ctx, args)
        local reasons = {"hotfix", "maintenance", "update", "crash_recovery"}
        local countdowns = {15, 30, 60, 300, 900}

        return {
            server_id = args.server_id or ("world-" .. ctx.random.int(1, 10)),
            countdown = ctx.random.choice(countdowns),
            reason = ctx.random.choice(reasons),
            estimated_downtime = ctx.random.int(5, 60)
        }
    end
}
