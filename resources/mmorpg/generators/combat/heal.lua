-- Combat Heal Generator

return {
    metadata = {
        name = "combat.heal",
        category = "COMBAT",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Healing done",
        text_template = "[{timestamp}] HEAL: {healer} healed {target} for {amount} ({skill}) [{is_crit}]",
        tags = {"combat", "healing", "player"},
        merge_groups = {"combat_effects"}
    },

    generate = function(ctx, args)
        local healing_classes = {"Priest", "Paladin", "Shaman", "Druid", "Monk"}

        local min_heal = 100
        local max_heal = 10000
        local crit_chance = 0.15
        local crit_multiplier = 2.0

        if ctx.data.constants and ctx.data.constants.combat then
            local cc = ctx.data.constants.combat
            min_heal = cc.min_heal or 100
            max_heal = cc.max_heal or 10000
            crit_chance = cc.crit_chance or 0.15
            crit_multiplier = cc.crit_multiplier or 2.0
        end

        local healer_class = ctx.random.choice(healing_classes)
        local is_crit = ctx.random.float() < crit_chance

        local amount = ctx.random.int(min_heal, max_heal)
        if is_crit then
            amount = math.floor(amount * crit_multiplier)
        end

        local healer = args.healer or ctx.gen.character_name()
        -- Self-heal 30% of the time
        local target
        if ctx.random.float() < 0.3 then
            target = healer
        else
            target = ctx.gen.character_name()
        end

        -- Get a skill name for the healer class
        local skill = ctx.gen.skill_name(healer_class)

        local overheal = 0
        if ctx.random.float() < 0.3 then
            overheal = ctx.random.int(0, math.floor(amount / 2))
        end

        return {
            healer = healer,
            healer_class = healer_class,
            target = target,
            amount = amount,
            overheal = overheal,
            skill = skill,
            is_crit = is_crit and "CRIT" or "normal"
        }
    end
}
