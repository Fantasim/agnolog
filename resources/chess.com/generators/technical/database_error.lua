return {
    metadata = {
        name = "technical.database_error",
        category = "TECHNICAL",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Database query error",
        text_template = "[{timestamp}] DB_ERROR: {error_type} on {table_name} - {error_message}",
        tags = {"technical", "database", "error"},
        merge_groups = {"db_ops"}
    },
    generate = function(ctx, args)
        local error_types = {
            "connection_timeout",
            "deadlock",
            "constraint_violation",
            "syntax_error",
            "connection_pool_exhausted",
            "table_lock_timeout"
        }

        local tables = {"games", "users", "moves", "ratings", "tournaments"}

        return {
            error_type = ctx.random.choice(error_types),
            table_name = ctx.random.choice(tables),
            error_message = "Database operation failed",
            query_type = ctx.random.choice({"SELECT", "INSERT", "UPDATE", "DELETE"}),
            retry_attempted = ctx.random.float(0, 1) < 0.8,
            duration_ms = ctx.random.int(100, 5000)
        }
    end
}
