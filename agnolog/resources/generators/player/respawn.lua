-- Player Respawn Generator

return {
    metadata = {
        name = "player.respawn",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player respawn",
        text_template = "[{timestamp}] RESPAWN: {char_name} at {location} ({respawn_type})",
        tags = {"player", "death"}
    },

    generate = function(ctx, args)
        local zones = {"Elwynn Forest", "Westfall", "Duskwood", "Stranglethorn Vale"}
        local zone = ctx.random.choice(zones)
        local respawn_types = {"graveyard", "spirit_healer", "soulstone", "battleground"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            location = zone,
            zone = zone,
            respawn_type = ctx.random.choice(respawn_types),
            time_dead = ctx.random.int(5, 300)
        }
    end
}
