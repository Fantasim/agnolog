-- Player Chat Guild Generator

return {
    metadata = {
        name = "player.chat_guild",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Guild chat message",
        text_template = "[{timestamp}] [GUILD:{guild}] {char_name}: {message}",
        tags = {"player", "chat", "guild"}
    },

    generate = function(ctx, args)
        local messages = {"Hey guildies!", "Anyone online?", "Need help with a quest",
            "Raid tonight?", "What time is the event?", "Grats on the level!"}

        if ctx.data.names and ctx.data.names.chat_messages and ctx.data.names.chat_messages.guild then
            messages = ctx.data.names.chat_messages.guild
        end

        -- Generate guild name
        local guild_prefixes = {"Order of", "Knights of", "The", "Ancient"}
        local guild_names = {"Phoenix", "Dragon", "Shadow", "Light", "Storm"}
        local guild = ctx.random.choice(guild_prefixes) .. " " .. ctx.random.choice(guild_names)

        if ctx.data.names and ctx.data.names.guild_names then
            local gd = ctx.data.names.guild_names
            if gd.prefixes and gd.names then
                guild = ctx.random.choice(gd.prefixes) .. " " .. ctx.random.choice(gd.names)
            end
        end

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            guild = args.guild or guild,
            message = ctx.random.choice(messages)
        }
    end
}
