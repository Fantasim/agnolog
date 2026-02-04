-- Player Chat Say Generator

return {
    metadata = {
        name = "player.chat_say",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Local chat message",
        text_template = "[{timestamp}] [SAY] {char_name}: {message}",
        tags = {"player", "chat"}
    },

    generate = function(ctx, args)
        local messages = {"Hello!", "Hi there!", "Anyone around?", "Nice weather today.",
            "Looking for a group!", "LFG!", "Thanks!", "GG", "Well played!"}

        if ctx.data.names and ctx.data.names.chat_messages and ctx.data.names.chat_messages.say then
            messages = ctx.data.names.chat_messages.say
        end

        local zones = {"Elwynn Forest", "Stormwind City", "Orgrimmar", "Ironforge"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            message = ctx.random.choice(messages),
            zone = args.zone or ctx.random.choice(zones)
        }
    end
}
