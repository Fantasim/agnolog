-- Combat Debuff Apply Generator

return {
    metadata = {
        name = "combat.debuff_apply",
        category = "COMBAT",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Debuff applied",
        text_template = "[{timestamp}] DEBUFF: {target} afflicted with {debuff_name} from {source}",
        tags = {"combat", "debuff", "aura"},
        merge_groups = {"combat_effects"}
    },

    generate = function(ctx, args)
        local debuffs = {
            "Curse of Agony", "Corruption", "Shadow Word: Pain", "Serpent Sting",
            "Rend", "Deep Wounds", "Mortal Strike", "Hunter's Mark",
            "Sunder Armor", "Faerie Fire", "Expose Armor", "Thunderclap",
            "Slow", "Crippling Poison", "Deadly Poison", "Mind Flay"
        }

        local target, target_type
        -- Target is usually mob (80%)
        if ctx.random.float() > 0.2 then
            target = ctx.gen.monster_name()
            target_type = "mob"
        else
            target = ctx.gen.character_name()
            target_type = "player"
        end

        local damage_per_tick = 0
        if ctx.random.float() < 0.5 then
            damage_per_tick = ctx.random.int(50, 500)
        end

        return {
            target = target,
            target_type = target_type,
            source = args.source or ctx.gen.character_name(),
            debuff_name = ctx.random.choice(debuffs),
            debuff_id = ctx.random.int(1000, 99999),
            duration = ctx.random.int(5, 60),
            damage_per_tick = damage_per_tick
        }
    end
}
