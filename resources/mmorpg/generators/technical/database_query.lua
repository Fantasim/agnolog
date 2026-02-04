-- Technical Database Query Generator

return {
    metadata = {
        name = "technical.database_query",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Database query executed",
        text_template = "[{timestamp}] DB_QUERY: {query_type} ({duration}ms, {rows} rows)",
        tags = {"technical", "database", "query"}
    },

    generate = function(ctx, args)
        local query_types = {
            "SELECT", "INSERT", "UPDATE", "DELETE",
            "TRANSACTION", "STORED_PROC", "INDEX_SCAN", "TABLE_SCAN"
        }

        local durations = {
            SELECT = {1, 100},
            INSERT = {1, 50},
            UPDATE = {1, 50},
            DELETE = {1, 30},
            TRANSACTION = {5, 200},
            STORED_PROC = {10, 500},
            INDEX_SCAN = {1, 50},
            TABLE_SCAN = {50, 1000}
        }

        if ctx.data.constants and ctx.data.constants.network then
            local nc = ctx.data.constants.network
            if nc.db_query_types then query_types = nc.db_query_types end
        end

        local query_type = ctx.random.choice(query_types)
        local dur_range = durations[query_type] or {1, 100}

        local tables = {
            "characters", "items", "guilds", "mail", "auctions",
            "quests", "achievements", "inventory", "stats"
        }

        return {
            query_type = query_type,
            duration = ctx.random.int(dur_range[1], dur_range[2]),
            rows = ctx.random.int(0, 10000),
            table_name = ctx.random.choice(tables),
            connection_pool = "pool_" .. ctx.random.int(1, 5)
        }
    end
}
