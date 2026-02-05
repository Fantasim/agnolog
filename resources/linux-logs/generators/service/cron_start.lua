-- Cron Start Generator
-- Generates cron job start log entries

return {
    metadata = {
        name = "service.cron_start",
        category = "SERVICE",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Cron job started",
        text_template = "[{timestamp}] CRON[{pid}]: ({user}) CMD ({command})",
        tags = {"cron", "scheduled"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local commands = {
            "/usr/bin/backup.sh",
            "/usr/local/bin/cleanup.sh",
            "/usr/bin/certbot renew",
            "cd /opt/app && ./run_job.sh",
            "/usr/bin/apt update",
            "/usr/bin/find /tmp -type f -atime +7 -delete",
            "/home/user/scripts/monitor.py",
            "/usr/bin/mysqldump -u backup mydb > /backup/db.sql"
        }

        return {
            pid = ctx.random.int(1000, 32768),
            user = ctx.random.choice({"root", ctx.gen.player_name()}),
            command = ctx.random.choice(commands)
        }
    end
}
