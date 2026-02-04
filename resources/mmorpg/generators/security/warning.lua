-- Admin Warning Generator

return {
    metadata = {
        name = "admin.warning",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Warning issued",
        text_template = "[{timestamp}] WARNING: {admin} warned {target}: {message}",
        tags = {"security", "admin", "warning"}
    },

    generate = function(ctx, args)
        local messages = {
            "Please follow the rules",
            "This is your first warning",
            "Continued behavior will result in a ban",
            "Watch your language",
            "Do not harass other players",
            "Exploiting is not allowed"
        }

        local admin_names = {"Alpha", "Beta", "Gamma", "Delta"}

        return {
            admin = "GM_" .. ctx.random.choice(admin_names),
            target = args.target or ctx.gen.character_name(),
            message = ctx.random.choice(messages),
            warning_count = ctx.random.int(1, 3)
        }
    end
}
