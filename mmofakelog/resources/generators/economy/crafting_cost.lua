-- Economy Crafting Cost Generator

return {
    metadata = {
        name = "economy.crafting_cost",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Crafting expense",
        text_template = "[{timestamp}] CRAFT_COST: {char_name} spent {cost}g crafting [{rarity}] {item_name}",
        tags = {"economy", "crafting", "item"}
    },

    generate = function(ctx, args)
        local professions = {"Blacksmithing", "Leatherworking", "Tailoring", "Engineering",
            "Alchemy", "Enchanting", "Jewelcrafting", "Inscription"}

        local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary"}
        local rarity_values = {
            Common = {10, 50},
            Uncommon = {50, 200},
            Rare = {200, 1000},
            Epic = {1000, 5000},
            Legendary = {5000, 50000}
        }

        if ctx.data.items and ctx.data.items.rarities then
            rarities = {}
            for _, r in ipairs(ctx.data.items.rarities) do
                table.insert(rarities, r.name or r)
            end
        end

        local rarity = ctx.random.choice(rarities)
        local value_range = rarity_values[rarity] or {10, 100}
        local base_value = ctx.random.int(value_range[1], value_range[2])
        local cost = math.floor(base_value * (0.1 + ctx.random.float() * 0.4))

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = ctx.gen.item_name(),
            rarity = rarity,
            cost = cost,
            profession = ctx.random.choice(professions),
            skill_level = ctx.random.int(1, 450)
        }
    end
}
