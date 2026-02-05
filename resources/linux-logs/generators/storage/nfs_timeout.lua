-- NFS Timeout Generator
-- Generates NFS timeout log entries

return {
    metadata = {
        name = "storage.nfs_timeout",
        category = "STORAGE",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "NFS timeout",
        text_template = "[{timestamp}] nfs: server {server} not responding, timed out",
        tags = {"storage", "nfs", "timeout"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        -- Build hostname from YAML data
        local prefixes = ctx.data.network.hostnames.prefixes or {"nfs"}
        local suffixes = ctx.data.network.hostnames.suffixes or {"01"}
        local server = ctx.random.choice(prefixes) .. "-" .. ctx.random.choice(suffixes)

        return {
            server = server,
            retries = ctx.random.int(1, 5),
            timeout_seconds = ctx.random.int(30, 300)
        }
    end
}
