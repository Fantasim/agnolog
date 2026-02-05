-- Group Add Generator
-- Generates group creation log entries

return {
    metadata = {
        name = "auth.group_add",
        category = "AUTH",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Group created",
        text_template = "[{timestamp}] groupadd[{pid}]: new group: name={group}, GID={gid}",
        tags = {"auth", "group", "admin"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local group_names = {"developers", "operators", "docker", "webadmin", "dbadmin", "appusers"}

        return {
            pid = ctx.random.int(500, 32768),
            group = ctx.random.choice(group_names),
            gid = ctx.random.int(1000, 60000)
        }
    end
}
