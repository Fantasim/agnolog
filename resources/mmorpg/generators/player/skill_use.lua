-- Player Skill Use Generator

return {
    metadata = {
        name = "player.skill_use",
        category = "PLAYER",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Skill/ability used",
        text_template = "[{timestamp}] SKILL: {char_name} used {skill_name} on {target}",
        tags = {"player", "combat", "skill"}
    },

    generate = function(ctx, args)
        local classes = {"Warrior", "Paladin", "Hunter", "Rogue", "Priest",
            "Shaman", "Mage", "Warlock", "Druid", "Death Knight"}
        local char_class = args.class or ctx.random.choice(classes)

        -- Get skill for class from data
        local skill = "Auto Attack"
        local skill_key = string.lower(string.gsub(char_class, " ", "_"))
        if ctx.data.classes and ctx.data.classes.skills and ctx.data.classes.skills[skill_key] then
            skill = ctx.random.choice(ctx.data.classes.skills[skill_key])
        end

        -- Determine target
        local target_types = {"mob", "player", "self"}
        local target_type = ctx.random.choice(target_types)
        local target

        if target_type == "self" then
            target = args.char_name or ctx.gen.character_name()
        elseif target_type == "player" then
            target = ctx.gen.character_name()
        else
            -- Generate monster name
            local monster_types = ctx.data.monsters and ctx.data.monsters.monster_types
            if monster_types and monster_types.prefixes and monster_types.names then
                local mtype = ctx.random.choice(monster_types.types or {"Beast"})
                local prefixes = monster_types.prefixes[mtype] or {"Wild"}
                local names = monster_types.names[mtype] or {"Creature"}
                target = ctx.random.choice(prefixes) .. " " .. ctx.random.choice(names)
            else
                target = "Wild Creature"
            end
        end

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            skill_name = skill,
            target = target,
            target_type = target_type,
            class = char_class
        }
    end
}
