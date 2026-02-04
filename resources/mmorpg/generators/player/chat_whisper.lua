-- Player Chat Whisper Generator

return {
    metadata = {
        name = "player.chat_whisper",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Private whisper message",
        text_template = "[{timestamp}] [WHISPER] {from_char} -> {to_char}: {message}",
        tags = {"player", "chat", "private"},
        merge_groups = {"chat"}
    },

    generate = function(ctx, args)
        local messages = {"Hey, got a sec?", "Thanks for the group!",
            "Want to trade?", "Nice gear!", "Are you in a guild?"}

        if ctx.data.names and ctx.data.names.chat_messages and ctx.data.names.chat_messages.whisper then
            messages = ctx.data.names.chat_messages.whisper
        end

        return {
            from_char = args.from_char or ctx.gen.character_name(),
            to_char = args.to_char or ctx.gen.character_name(),
            message = ctx.random.choice(messages)
        }
    end
}
