-- Server Hotfix Applied Generator

return {
    metadata = {
        name = "server.hotfix_applied",
        category = "SERVER",
        severity = "INFO",
        recurrence = "RARE",
        description = "Hotfix deployed",
        text_template = "[{timestamp}] HOTFIX: Applied patch {patch_id} ({description})",
        tags = {"server", "hotfix", "patch"}
    },

    generate = function(ctx, args)
        local descriptions = {
            "Fixed crash on dungeon load",
            "Corrected item stats",
            "Resolved exploit",
            "Updated drop rates",
            "Fixed quest completion bug",
            "Patched security vulnerability",
            "Corrected NPC behavior"
        }

        local severities = {"low", "medium", "high", "critical"}

        return {
            patch_id = "HF-" .. ctx.random.int(2024001, 2024999),
            description = ctx.random.choice(descriptions),
            requires_restart = ctx.random.float() < 0.3,
            severity = ctx.random.choice(severities)
        }
    end
}
