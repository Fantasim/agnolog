-- Technical Connection Timeout Generator

return {
    metadata = {
        name = "technical.connection_timeout",
        category = "TECHNICAL",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Connection timeout",
        text_template = "[{timestamp}] CONN_TIMEOUT: {client_ip} after {timeout}ms (last_activity: {last_activity}s ago)",
        tags = {"technical", "network", "timeout"}
    },

    generate = function(ctx, args)
        local connection_timeout_ms = 30000

        if ctx.data.constants and ctx.data.constants.network then
            connection_timeout_ms = ctx.data.constants.network.connection_timeout_ms or 30000
        end

        return {
            client_ip = ctx.gen.ip_address(),
            timeout = ctx.random.int(math.floor(connection_timeout_ms / 2), connection_timeout_ms * 2),
            last_activity = ctx.random.int(30, 300),
            connection_id = "conn_" .. ctx.random.int(100000, 999999),
            session_id = ctx.gen.session_id()
        }
    end
}
