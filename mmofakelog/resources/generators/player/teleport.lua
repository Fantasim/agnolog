-- Player Teleport Generator

return {
    metadata = {
        name = "player.teleport",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player teleported",
        text_template = "[{timestamp}] TELEPORT: {char_name} from {from_zone} to {to_zone} ({method})",
        tags = {"player", "travel"}
    },

    methods = {
        "hearthstone", "mage_portal", "warlock_summon", "flight_master",
        "ship", "zeppelin", "dungeon_finder", "battleground"
    },

    generate = function(ctx, args)
        local zones = {"Elwynn Forest", "Stormwind City", "Ironforge", "Orgrimmar",
            "Darnassus", "Thunder Bluff", "Duskwood", "Stranglethorn Vale"}

        local from_zone = ctx.random.choice(zones)
        local to_zone = ctx.random.choice(zones)

        -- Ensure different zones
        while to_zone == from_zone do
            to_zone = ctx.random.choice(zones)
        end

        local methods = {
            "hearthstone", "mage_portal", "warlock_summon", "flight_master",
            "ship", "zeppelin", "dungeon_finder", "battleground"
        }

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            from_zone = from_zone,
            to_zone = to_zone,
            method = ctx.random.choice(methods)
        }
    end
}
