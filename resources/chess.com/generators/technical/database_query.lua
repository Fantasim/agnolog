return {
    metadata = {
        name = "technical.database_query",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Database query executed",
        text_template = "[{timestamp}] DB_QUERY: {query_type} on {table_name} - {duration_ms}ms",
        tags = {"technical", "database", "query"},
        merge_groups = {"db_ops"}
    },
    generate = function(ctx, args)
        local query_types = {"SELECT", "INSERT", "UPDATE", "DELETE", "JOIN"}
        local tables = {"games", "users", "moves", "ratings", "tournaments", "sessions", "achievements"}

        return {
            query_type = ctx.random.choice(query_types),
            table_name = ctx.random.choice(tables),
            duration_ms = ctx.random.int(5, 500),
            rows_affected = ctx.random.int(1, 1000),
            connection_pool_id = ctx.random.int(1, 50),
            cache_hit = ctx.random.float(0, 1) < 0.7,
            index_used = ctx.random.float(0, 1) < 0.85
        }
    end
}
