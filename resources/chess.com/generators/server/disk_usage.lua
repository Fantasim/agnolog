return {
    metadata = {
        name = "server.disk_usage",
        category = "SERVER",
        severity = "DEBUG",
        recurrence = "NORMAL",
        description = "Server disk usage metrics",
        text_template = "[{timestamp}] DISK: {disk_percent}% used ({disk_used_gb}GB / {disk_total_gb}GB)",
        tags = {"server", "metrics", "disk"},
        merge_groups = {"server_metrics"}
    },
    generate = function(ctx, args)
        local disk_total_gb = ctx.random.choice({500, 1000, 2000, 4000})
        local disk_percent = ctx.random.int(30, 85)
        local disk_used_gb = (disk_total_gb * disk_percent) / 100

        return {
            server_id = ctx.random.choice({"game-server-01", "db-server-01", "storage-server-01"}),
            disk_percent = disk_percent,
            disk_used_gb = math.floor(disk_used_gb),
            disk_total_gb = disk_total_gb,
            inodes_percent = ctx.random.int(10, 50),
            disk_io_mb_per_sec = ctx.random.int(50, 500)
        }
    end
}
