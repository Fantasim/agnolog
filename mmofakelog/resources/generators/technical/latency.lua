-- Technical Latency Generator

return {
    metadata = {
        name = "technical.latency",
        category = "TECHNICAL",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Latency measurement",
        text_template = "[{timestamp}] LATENCY: {client} ping {latency}ms (avg: {avg}ms, jitter: {jitter}ms)",
        tags = {"technical", "network", "latency"}
    },

    generate = function(ctx, args)
        local min_latency = 10
        local max_latency = 200
        local typical_latency = 50
        local spike_latency = 1000

        if ctx.data.constants and ctx.data.constants.network then
            local nc = ctx.data.constants.network
            min_latency = nc.min_latency_ms or 10
            max_latency = nc.max_latency_ms or 200
            typical_latency = nc.typical_latency_ms or 50
            spike_latency = nc.spike_latency_ms or 1000
        end

        local latency
        -- Mostly normal, occasional spike (5% chance)
        if ctx.random.float() < 0.05 then
            latency = ctx.random.int(max_latency, spike_latency)
        else
            latency = math.floor(ctx.random.gauss(typical_latency, 20))
            latency = math.max(min_latency, math.min(latency, max_latency))
        end

        return {
            client = ctx.gen.ip_address() .. ":" .. ctx.random.int(1024, 65535),
            session_id = ctx.gen.session_id(),
            latency = latency,
            avg = ctx.random.int(typical_latency - 20, typical_latency + 20),
            jitter = ctx.random.int(1, 30),
            packet_loss = math.floor(ctx.random.float() * 200) / 100
        }
    end
}
