-- Server Config Reload Generator

return {
    metadata = {
        name = "server.config_reload",
        category = "SERVER",
        severity = "INFO",
        recurrence = "RARE",
        description = "Configuration reloaded",
        text_template = "[{timestamp}] CONFIG_RELOAD: Reloaded {config_file} ({changes} changes)",
        tags = {"server", "config", "admin"}
    },

    generate = function(ctx, args)
        local config_files = {"server.conf", "world.conf", "rates.conf", "anticheat.conf",
            "chat.conf", "guild.conf", "pvp.conf", "loot.conf"}

        return {
            config_file = ctx.random.choice(config_files),
            changes = ctx.random.int(1, 20),
            admin = "Admin" .. ctx.random.int(1, 10)
        }
    end
}
