-- Server Start Generator
-- Generates server startup log entries

return {
    metadata = {
        name = "server.start",
        category = "SERVER",
        severity = "INFO",
        recurrence = "RARE",
        description = "Server startup event",
        text_template = "[{timestamp}] SERVER START: {server_id} v{version} region:{region}",
        tags = {"server", "lifecycle"},
        merge_groups = {"server_state"}
    },

    generate = function(ctx, args)
        local regions = {"NA-West", "NA-East", "EU-West", "EU-East", "Asia-Pacific", "Oceania"}
        if ctx.data.constants and ctx.data.constants.server and ctx.data.constants.server.regions then
            regions = ctx.data.constants.server.regions
        end

        return {
            server_id = args.server_id or string.format("server-%02d", ctx.random.int(1, 20)),
            version = string.format("%d.%d.%d", ctx.random.int(1, 3), ctx.random.int(0, 9), ctx.random.int(0, 99)),
            region = ctx.random.choice(regions),
            startup_time_ms = ctx.random.int(5000, 30000),
            config_loaded = true,
            database_connected = true,
            services_ready = ctx.random.int(10, 30)
        }
    end
}
