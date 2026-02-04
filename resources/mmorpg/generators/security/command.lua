-- Admin Command Generator

return {
    metadata = {
        name = "admin.command",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Admin command executed",
        text_template = "[{timestamp}] ADMIN_CMD: {admin} executed: {command}",
        tags = {"security", "admin", "command"},
        merge_groups = {"gm_actions"}
    },

    generate = function(ctx, args)
        local commands = {
            ".lookup player {target}",
            ".ticket list",
            ".server info",
            ".gm on",
            ".revive {target}",
            ".teleport {zone}",
            ".additem {item_id} 1",
            ".announce {message}",
            ".shutdown 300",
            ".ban account {target}"
        }

        local zones = {"Stormwind", "Orgrimmar", "Elwynn Forest"}
        if ctx.data.world and ctx.data.world.cities then
            zones = {}
            for _, city in ipairs(ctx.data.world.cities) do
                table.insert(zones, city.name or city)
            end
        end

        local admin_names = {"Alpha", "Beta", "Gamma", "Delta"}

        local command = ctx.random.choice(commands)
        command = string.gsub(command, "{target}", ctx.gen.character_name())
        command = string.gsub(command, "{zone}", ctx.random.choice(zones))
        command = string.gsub(command, "{item_id}", tostring(ctx.random.int(10000, 99999)))
        command = string.gsub(command, "{message}", "Server maintenance in 5 minutes")

        return {
            admin = "GM_" .. ctx.random.choice(admin_names),
            command = command,
            success = ctx.random.float() > 0.05
        }
    end
}
