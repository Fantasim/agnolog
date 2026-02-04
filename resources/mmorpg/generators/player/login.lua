-- Player Login Generator
-- Generates player login log entries

return {
    metadata = {
        name = "player.login",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player login event",
        text_template = "[{timestamp}] LOGIN: {username} ({char_name}) from {ip} (region: {region})",
        tags = {"auth", "player", "session"},
        merge_groups = {"sessions"}
    },

    generate = function(ctx, args)
        -- Get data from YAML resources
        local regions = ctx.data.constants.server.regions or {"NA-West", "NA-East", "EU-West"}
        local classes = ctx.data.classes.classes.classes or {}
        local races_data = ctx.data.classes.races or {}

        -- Build race list from alliance + horde + neutral
        local races = {}
        if races_data.alliance then
            for _, race in ipairs(races_data.alliance) do
                table.insert(races, race)
            end
        end
        if races_data.horde then
            for _, race in ipairs(races_data.horde) do
                table.insert(races, race)
            end
        end
        if races_data.neutral then
            for _, race in ipairs(races_data.neutral) do
                table.insert(races, race)
            end
        end

        -- Fallback if races is empty
        if #races == 0 then
            races = {"Human", "Orc", "Dwarf", "Troll"}
        end

        -- Get class name
        local class_name = "Warrior"
        if classes and #classes > 0 then
            local class_entry = ctx.random.choice(classes)
            if type(class_entry) == "table" and class_entry.name then
                class_name = class_entry.name
            elseif type(class_entry) == "string" then
                class_name = class_entry
            end
        end

        -- Use built-in generators for names
        local username = args.username or ctx.gen.player_name()
        local char_name = args.char_name or ctx.gen.character_name()
        local ip = args.ip or ctx.gen.ip_address()
        local session_id = args.session_id or ctx.gen.session_id()

        -- Generate level based on constants
        local max_level = 60
        if ctx.data.constants and ctx.data.constants.server and ctx.data.constants.server.player_limits then
            max_level = ctx.data.constants.server.player_limits.max_level or 60
        end

        return {
            username = username,
            char_name = char_name,
            ip = ip,
            region = ctx.random.choice(regions),
            client_version = string.format("1.%d.%d", ctx.random.int(0, 5), ctx.random.int(0, 20)),
            session_id = session_id,
            level = ctx.random.int(1, max_level),
            class = class_name,
            race = ctx.random.choice(races)
        }
    end
}
