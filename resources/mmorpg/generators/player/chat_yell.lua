-- Player Chat Yell Generator

return {
    metadata = {
        name = "player.chat_yell",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Yell chat message",
        text_template = "[{timestamp}] [YELL] {char_name}: {message}",
        tags = {"player", "chat"},
        merge_groups = {"chat"}
    },

    generate = function(ctx, args)
        local messages = {"HELP!", "INCOMING!", "RUN!", "BOSS INCOMING!",
            "VICTORY!", "WE DID IT!", "AMAZING!"}

        if ctx.data.names and ctx.data.names.chat_messages and ctx.data.names.chat_messages.yell then
            messages = ctx.data.names.chat_messages.yell
        end

        local zones = {"Elwynn Forest", "Stormwind City", "Orgrimmar"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            message = ctx.random.choice(messages),
            zone = ctx.random.choice(zones)
        }
    end
}
