-- Server Tick Generator

return {
    metadata = {
        name = "server.tick",
        category = "SERVER",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Server tick timing",
        text_template = "[{timestamp}] TICK: #{tick_id} ({tick_time}ms, {entity_count} entities, TPS: {tps})",
        tags = {"server", "performance", "tick"}
    },

    generate = function(ctx, args)
        local tick_time, tps
        local tick_time_min = 10
        local tick_time_max = 50
        local tps_min = 18
        local tps_max = 20

        if ctx.data.constants and ctx.data.constants.server then
            local sc = ctx.data.constants.server
            tick_time_min = sc.tick_time_ms_min or 10
            tick_time_max = sc.tick_time_ms_max or 50
            tps_min = sc.min_tps or 18
            tps_max = sc.max_tps or 20
        end

        -- Simulate occasional lag spikes (5% chance)
        if ctx.random.float() < 0.05 then
            tick_time = ctx.random.int(100, 500)
            tps = ctx.random.int(5, 15)
        else
            tick_time = ctx.random.int(tick_time_min, tick_time_max)
            tps = ctx.random.int(tps_min, tps_max)
        end

        return {
            tick_id = ctx.random.int(1, 1000000000),
            tick_time = tick_time,
            entity_count = ctx.random.int(10000, 100000),
            tps = tps,
            world_time = ctx.random.int(0, 24000)
        }
    end
}
