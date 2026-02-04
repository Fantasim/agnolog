-- Economy Trade Request Generator

return {
    metadata = {
        name = "economy.trade_request",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Trade initiated",
        text_template = "[{timestamp}] TRADE_REQ: {from_char} requested trade with {to_char}",
        tags = {"economy", "trade", "player"}
    },

    generate = function(ctx, args)
        local zones = {"Stormwind", "Orgrimmar", "Ironforge", "Thunder Bluff", "Darnassus"}

        if ctx.data.world and ctx.data.world.cities then
            zones = {}
            for _, city in ipairs(ctx.data.world.cities) do
                table.insert(zones, city.name or city)
            end
        end

        return {
            from_char = args.from_char or ctx.gen.character_name(),
            to_char = args.to_char or ctx.gen.character_name(),
            zone = ctx.random.choice(zones)
        }
    end
}
