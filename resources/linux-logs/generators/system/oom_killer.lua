-- OOM Killer Generator
-- Generates out-of-memory killer log entries

return {
    metadata = {
        name = "system.oom_killer",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "OOM killer invoked",
        text_template = "[{timestamp}] kernel: Out of memory: Killed process {pid} ({process}) total-vm:{total_vm}kB, anon-rss:{anon_rss}kB, file-rss:{file_rss}kB, shmem-rss:{shmem_rss}kB, UID:{uid} score {score}",
        tags = {"oom", "memory", "kernel"},
        merge_groups = {"system_errors"}
    },

    generate = function(ctx, args)
        local processes = {
            "java", "mysqld", "postgres", "chrome", "firefox",
            "apache2", "nginx", "python", "node", "ruby"
        }

        local limits = ctx.data.constants.system_limits.memory or {}

        return {
            pid = ctx.random.int(100, 32768),
            process = ctx.random.choice(processes),
            total_vm = ctx.random.int(1000000, 16000000),
            anon_rss = ctx.random.int(500000, 8000000),
            file_rss = ctx.random.int(10000, 1000000),
            shmem_rss = ctx.random.int(0, 500000),
            uid = ctx.random.int(1000, 60000),
            score = ctx.random.int(limits.oom_score_min or -1000, limits.oom_score_max or 1000)
        }
    end
}
