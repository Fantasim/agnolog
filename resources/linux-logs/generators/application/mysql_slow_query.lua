-- MySQL Slow Query Generator
-- Generates MySQL slow query log entries

return {
    metadata = {
        name = "application.mysql_slow_query",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "MySQL slow query",
        text_template = "[{timestamp}] mysqld[{pid}]: Slow query ({duration}s): {query}",
        tags = {"mysql", "database", "performance"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local queries = {
            "SELECT * FROM users WHERE created_at > '2020-01-01'",
            "SELECT COUNT(*) FROM orders JOIN order_items ON orders.id = order_items.order_id",
            "UPDATE products SET stock = stock - 1 WHERE id IN (SELECT product_id FROM cart_items)",
            "DELETE FROM logs WHERE timestamp < DATE_SUB(NOW(), INTERVAL 30 DAY)"
        }

        return {
            pid = ctx.random.int(1000, 32768),
            duration = string.format("%.2f", ctx.random.float(2, 30)),
            query = ctx.random.choice(queries),
            rows_examined = ctx.random.int(1000, 1000000)
        }
    end
}
