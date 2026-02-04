-- Economy Repair Cost Generator

return {
    metadata = {
        name = "economy.repair_cost",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Equipment repair",
        text_template = "[{timestamp}] REPAIR: {char_name} repaired equipment for {cost}g (durability: {durability_restored}%)",
        tags = {"economy", "repair", "equipment"}
    },

    generate = function(ctx, args)
        local zones = {"Stormwind", "Orgrimmar", "Ironforge", "Thunder Bluff"}

        if ctx.data.world and ctx.data.world.cities then
            zones = {}
            for _, city in ipairs(ctx.data.world.cities) do
                table.insert(zones, city.name or city)
            end
        end

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            cost = ctx.random.int(5, 200),
            durability_restored = ctx.random.int(10, 100),
            items_repaired = ctx.random.int(1, 16),
            zone = ctx.random.choice(zones)
        }
    end
}
