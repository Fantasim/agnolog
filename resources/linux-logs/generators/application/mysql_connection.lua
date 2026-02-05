-- MySQL Connection Generator
-- Generates MySQL connection log entries

return {
    metadata = {
        name = "application.mysql_connection",
        category = "APPLICATION",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "MySQL connection",
        text_template = "[{timestamp}] mysqld[{pid}]: Connect {user}@{host} on {database}",
        tags = {"mysql", "database", "connection"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local databases = {"myapp", "wordpress", "production", "test", "analytics"}

        return {
            pid = ctx.random.int(1000, 32768),
            user = ctx.gen.player_name(),
            host = ctx.gen.ip_address(),
            database = ctx.random.choice(databases)
        }
    end
}
