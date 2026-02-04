-- Security Speed Hack Generator

return {
    metadata = {
        name = "security.speed_hack",
        category = "SECURITY",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Speed hack detected",
        text_template = "[{timestamp}] SPEED_HACK: {char_name} moved {distance}u in {time}ms (max: {max_distance}u)",
        tags = {"security", "cheat", "speed"}
    },

    generate = function(ctx, args)
        local time_ms = ctx.random.int(100, 1000)
        local max_distance = time_ms * 0.05  -- Normal max speed
        local actual_distance = max_distance * (2 + ctx.random.float() * 8)  -- Detected hack

        local zones = {"Stormwind", "Orgrimmar", "Elwynn Forest"}
        if ctx.data.world and ctx.data.world.cities then
            zones = {}
            for _, city in ipairs(ctx.data.world.cities) do
                table.insert(zones, city.name or city)
            end
        end

        local actions = {"warning", "kick", "temp_ban", "flagged"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            distance = math.floor(actual_distance * 10) / 10,
            time = time_ms,
            max_distance = math.floor(max_distance * 10) / 10,
            zone = ctx.random.choice(zones),
            action_taken = ctx.random.choice(actions)
        }
    end
}
