-- Combat Damage Taken Generator

return {
    metadata = {
        name = "combat.damage_taken",
        category = "COMBAT",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Damage taken",
        text_template = "[{timestamp}] DMG_TAKEN: {target} took {damage} {damage_type} from {source}",
        tags = {"combat", "damage", "player"}
    },

    generate = function(ctx, args)
        local damage_types = {"Physical", "Fire", "Frost", "Arcane", "Nature", "Shadow", "Holy"}

        local min_damage = 50
        local max_damage = 5000

        if ctx.data.constants and ctx.data.constants.combat then
            local cc = ctx.data.constants.combat
            min_damage = cc.min_damage or 50
            max_damage = cc.max_damage or 5000
        end

        local source, source_type
        -- Source is usually mob (70%)
        if ctx.random.float() > 0.3 then
            source = ctx.gen.monster_name()
            source_type = "mob"
        else
            source = ctx.gen.character_name()
            source_type = "player"
        end

        local damage = ctx.random.int(min_damage, max_damage)
        local absorbed = 0
        if ctx.random.float() < 0.2 then
            absorbed = ctx.random.int(0, math.floor(damage / 4))
        end

        return {
            target = args.target or ctx.gen.character_name(),
            source = source,
            source_type = source_type,
            damage = damage,
            damage_absorbed = absorbed,
            damage_type = ctx.random.choice(damage_types),
            health_remaining = ctx.random.int(0, 50000)
        }
    end
}
