-- Player Chat Party Generator

return {
    metadata = {
        name = "player.chat_party",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Party chat message",
        text_template = "[{timestamp}] [PARTY] {char_name}: {message}",
        tags = {"player", "chat", "party"},
        merge_groups = {"chat"}
    },

    generate = function(ctx, args)
        local messages = {"Ready?", "Let's go!", "Follow me", "Wait up",
            "Need heals", "Out of mana", "Low HP", "Pulling now",
            "CC that mob", "Focus the boss", "Stack up", "Spread out"}

        if ctx.data.names and ctx.data.names.chat_messages and ctx.data.names.chat_messages.party then
            messages = ctx.data.names.chat_messages.party
        end

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            message = ctx.random.choice(messages),
            party_size = ctx.random.int(2, 5)
        }
    end
}
