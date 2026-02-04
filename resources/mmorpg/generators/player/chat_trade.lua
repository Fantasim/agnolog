-- Player Chat Trade Generator

return {
    metadata = {
        name = "player.chat_trade",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Trade chat message",
        text_template = "[{timestamp}] [TRADE] {char_name}: {message}",
        tags = {"player", "chat", "trade"},
        merge_groups = {"chat"}
    },

    generate = function(ctx, args)
        local messages = {"WTS [Epic Sword] 500g", "WTB [Health Potion] x20",
            "Selling crafting mats!", "Buying rare recipes",
            "LF Blacksmith for crafting", "Enchanter available for tips"}

        if ctx.data.names and ctx.data.names.chat_messages and ctx.data.names.chat_messages.trade then
            messages = ctx.data.names.chat_messages.trade
        end

        local cities = {"Stormwind", "Orgrimmar", "Ironforge", "Thunder Bluff"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            message = ctx.random.choice(messages),
            city = ctx.random.choice(cities)
        }
    end
}
