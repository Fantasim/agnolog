-- Technical Error Generator

return {
    metadata = {
        name = "technical.error",
        category = "TECHNICAL",
        severity = "ERROR",
        recurrence = "NORMAL",
        description = "General error",
        text_template = "[{timestamp}] ERROR: {error_code} - {message}",
        tags = {"technical", "error", "system"}
    },

    generate = function(ctx, args)
        local error_codes = {
            E001 = "Connection failed",
            E002 = "Authentication timeout",
            E003 = "Invalid session",
            E004 = "Database connection lost",
            E005 = "Cache miss critical",
            E006 = "Rate limit exceeded",
            E007 = "Invalid packet format",
            E008 = "Resource not found",
            E009 = "Permission denied",
            E010 = "Internal server error"
        }

        if ctx.data.constants and ctx.data.constants.error_codes then
            error_codes = ctx.data.constants.error_codes
        end

        local codes = {}
        for code, _ in pairs(error_codes) do
            table.insert(codes, code)
        end

        local error_code = ctx.random.choice(codes)

        local modules = {
            "auth", "world", "chat", "combat", "trade",
            "guild", "mail", "auction", "quest", "inventory"
        }

        return {
            error_code = error_code,
            message = error_codes[error_code] or "Unknown error",
            module = ctx.random.choice(modules),
            recoverable = ctx.random.float() > 0.2
        }
    end
}
