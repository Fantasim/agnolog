-- Combat Mob Kill Generator

return {
    metadata = {
        name = "combat.mob_kill",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Monster killed",
        text_template = "[{timestamp}] MOB_KILL: {char_name} killed {mob_name} (+{xp} XP)",
        tags = {"combat", "kill", "monster"}
    },

    generate = function(ctx, args)
        local min_mob_xp = 10
        local max_mob_xp = 500

        if ctx.data.constants and ctx.data.constants.combat then
            local cc = ctx.data.constants.combat
            min_mob_xp = cc.min_mob_xp or 10
            max_mob_xp = cc.max_mob_xp or 500
        end

        local mob_name = ctx.gen.monster_name()
        local mob_level = ctx.random.int(1, 60)
        local is_elite = ctx.random.float() < 0.1
        local is_rare = ctx.random.float() < 0.05

        local xp = ctx.random.int(min_mob_xp, max_mob_xp)
        if is_elite then
            xp = xp * 3
        end

        local monster_types = {"Beast", "Humanoid", "Undead", "Elemental", "Demon", "Dragonkin"}
        if ctx.data.monsters and ctx.data.monsters.monster_types then
            monster_types = {}
            for _, mt in ipairs(ctx.data.monsters.monster_types) do
                table.insert(monster_types, mt.name or mt)
            end
        end

        local zones = {"Elwynn Forest", "Westfall", "Duskwood"}
        if ctx.data.world and ctx.data.world.leveling_zones then
            zones = {}
            for _, z in ipairs(ctx.data.world.leveling_zones) do
                table.insert(zones, z.name or z)
            end
        end

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            mob_id = ctx.random.int(10000, 99999),
            mob_name = mob_name,
            mob_level = mob_level,
            mob_type = ctx.random.choice(monster_types),
            xp = xp,
            is_elite = is_elite,
            is_rare = is_rare,
            zone = ctx.random.choice(zones)
        }
    end
}
