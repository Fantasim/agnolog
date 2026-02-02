-- Technical Database Error Generator

return {
    metadata = {
        name = "technical.database_error",
        category = "TECHNICAL",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Database error",
        text_template = "[{timestamp}] DB_ERROR: {error_code} - {message}",
        tags = {"technical", "database", "error"}
    },

    generate = function(ctx, args)
        local errors = {
            {code = "CONN_LOST", message = "Connection to database lost"},
            {code = "TIMEOUT", message = "Query execution timeout"},
            {code = "DEADLOCK", message = "Transaction deadlock detected"},
            {code = "CONSTRAINT", message = "Constraint violation"},
            {code = "DUPLICATE", message = "Duplicate key violation"},
            {code = "DISK_FULL", message = "Disk space exhausted"},
            {code = "CORRUPT", message = "Data corruption detected"},
            {code = "POOL_EXHAUSTED", message = "Connection pool exhausted"}
        }

        local query_types = {
            "SELECT", "INSERT", "UPDATE", "DELETE"
        }

        if ctx.data.constants and ctx.data.constants.network then
            local nc = ctx.data.constants.network
            if nc.db_query_types then query_types = nc.db_query_types end
        end

        local err = ctx.random.choice(errors)

        local tables = {"characters", "items", "guilds", "mail"}

        return {
            error_code = err.code,
            message = err.message,
            query_type = ctx.random.choice(query_types),
            table_name = ctx.random.choice(tables),
            retry_count = ctx.random.int(0, 3),
            recovered = ctx.random.float() > 0.3
        }
    end
}
