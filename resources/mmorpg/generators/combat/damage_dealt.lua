-- Combat Damage Dealt Generator
-- Generates combat damage log entries with hit/crit/miss mechanics

return {
    metadata = {
        name = "combat.damage_dealt",
        category = "COMBAT",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Combat damage dealt event",
        text_template = "[{timestamp}] DMG: {attacker} -> {target} {damage} {damage_type} ({skill}) [{result}]",
        tags = {"combat", "damage"},
        merge_groups = {"damage"}
    },

    generate = function(ctx, args)
        -- Get combat constants
        local min_damage = 1
        local max_damage = 50000
        local crit_chance = 0.05
        local dodge_chance = 0.05
        local parry_chance = 0.05
        local block_chance = 0.10
        local crit_multiplier = 2.0

        if ctx.data.constants and ctx.data.constants.combat then
            local combat = ctx.data.constants.combat
            if combat.damage then
                min_damage = combat.damage.min or min_damage
                max_damage = combat.damage.max or max_damage
                crit_multiplier = combat.damage.crit_multiplier or crit_multiplier
            end
            if combat.chances then
                crit_chance = combat.chances.crit or crit_chance
                dodge_chance = combat.chances.dodge or dodge_chance
                parry_chance = combat.chances.parry or parry_chance
                block_chance = combat.chances.block or block_chance
            end
        end

        -- Get damage types
        local damage_types = {"Physical", "Fire", "Frost", "Arcane", "Nature", "Shadow", "Holy"}
        if ctx.data.constants and ctx.data.constants.combat and ctx.data.constants.combat.damage_types then
            damage_types = ctx.data.constants.combat.damage_types
        end

        -- Combat roll
        local roll = ctx.random.float(0, 1)
        local result, damage

        if roll < crit_chance then
            result = "crit"
            damage = math.floor(ctx.random.int(min_damage, max_damage) * crit_multiplier)
        elseif roll < crit_chance + dodge_chance then
            result = "dodge"
            damage = 0
        elseif roll < crit_chance + dodge_chance + parry_chance then
            result = "parry"
            damage = 0
        elseif roll < crit_chance + dodge_chance + parry_chance + block_chance then
            result = "block"
            damage = math.floor(ctx.random.int(min_damage, max_damage) / 2)
        else
            result = "hit"
            damage = ctx.random.int(min_damage, max_damage)
        end

        -- Determine target (mob or player)
        local target, target_type
        if ctx.random.float(0, 1) > 0.3 then
            -- Monster target - build name from monster data
            local monster_types = ctx.data.monsters and ctx.data.monsters.monster_types
            if monster_types and monster_types.types and monster_types.prefixes and monster_types.names then
                local mtype = ctx.random.choice(monster_types.types)
                local prefixes = monster_types.prefixes[mtype]
                local names = monster_types.names[mtype]
                if prefixes and names then
                    target = ctx.random.choice(prefixes) .. " " .. ctx.random.choice(names)
                else
                    target = "Wild Creature"
                end
            else
                target = "Wild Creature"
            end
            target_type = "mob"
        else
            target = ctx.gen.character_name()
            target_type = "player"
        end

        -- Get skill from class skills
        local skill = "Auto Attack"
        local classes = ctx.data.classes and ctx.data.classes.classes and ctx.data.classes.classes.classes
        if classes and #classes > 0 then
            local class_entry = ctx.random.choice(classes)
            local class_name = type(class_entry) == "table" and class_entry.name or class_entry
            -- Try to get skills for this class
            local skill_key = string.lower(string.gsub(class_name, " ", "_"))
            local class_skills = ctx.data.classes and ctx.data.classes.skills and ctx.data.classes.skills[skill_key]
            if class_skills then
                skill = ctx.random.choice(class_skills)
            end
        end

        return {
            attacker = args.attacker or ctx.gen.character_name(),
            target = target,
            target_type = target_type,
            damage = damage,
            damage_type = ctx.random.choice(damage_types),
            skill = skill,
            result = result,
            overkill = (result == "hit" or result == "crit") and math.max(0, damage - ctx.random.int(100, 10000)) or 0
        }
    end
}
