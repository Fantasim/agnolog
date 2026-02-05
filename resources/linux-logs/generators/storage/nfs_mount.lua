-- NFS Mount Generator
-- Generates NFS mount log entries

return {
    metadata = {
        name = "storage.nfs_mount",
        category = "STORAGE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "NFS mount",
        text_template = "[{timestamp}] mount.nfs: mounting {server}:{export} on {mount_point}",
        tags = {"storage", "nfs", "mount"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local mount_points = ctx.data.filesystem.paths.mount_points or {"/mnt/nfs", "/mnt/data"}
        local exports = {"/export/data", "/export/home", "/export/backup", "/share/files"}

        -- Build hostname from YAML data
        local prefixes = ctx.data.network.hostnames.prefixes or {"nfs"}
        local suffixes = ctx.data.network.hostnames.suffixes or {"01"}
        local server = ctx.random.choice(prefixes) .. "-" .. ctx.random.choice(suffixes)

        return {
            server = server,
            export = ctx.random.choice(exports),
            mount_point = ctx.random.choice(mount_points)
        }
    end
}
