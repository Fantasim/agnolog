-- Player Mount Summon Generator

return {
    metadata = {
        name = "player.mount_summon",
        category = "PLAYER",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Mount summoned",
        text_template = "[{timestamp}] MOUNT: {char_name} summoned {mount_name}",
        tags = {"player", "mount", "travel"}
    },

    mounts = {
        "Swift Brown Horse", "Striped Frostsaber", "Swift Mechanostrider",
        "Swift Mistsaber", "Timber Wolf", "Dire Wolf", "Kodo",
        "Raptor", "Skeletal Horse", "Hawkstrider", "Elekk",
        "Gryphon", "Wind Rider", "Dragon", "Phoenix"
    },

    generate = function(ctx, args)
        local mounts = {
            "Swift Brown Horse", "Striped Frostsaber", "Swift Mechanostrider",
            "Swift Mistsaber", "Timber Wolf", "Dire Wolf", "Kodo",
            "Raptor", "Skeletal Horse", "Hawkstrider", "Elekk",
            "Gryphon", "Wind Rider", "Dragon", "Phoenix"
        }
        local speeds = {60, 100, 150, 310}
        local zones = {"Elwynn Forest", "Durotar", "Westfall", "Stranglethorn Vale"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            mount_name = ctx.random.choice(mounts),
            mount_speed = ctx.random.choice(speeds),
            zone = ctx.random.choice(zones)
        }
    end
}
