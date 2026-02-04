-- Combat Buff Apply Generator

return {
    metadata = {
        name = "combat.buff_apply",
        category = "COMBAT",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Buff applied",
        text_template = "[{timestamp}] BUFF: {target} gained {buff_name} from {source} ({duration}s)",
        tags = {"combat", "buff", "aura"},
        merge_groups = {"combat_effects"}
    },

    generate = function(ctx, args)
        local buffs = {
            "Power Word: Fortitude", "Mark of the Wild", "Arcane Intellect",
            "Blessing of Kings", "Bloodlust", "Heroism", "Battle Shout",
            "Trueshot Aura", "Devotion Aura", "Mana Spring", "Windfury",
            "Flask of the Titans", "Elixir of Giants", "Well Fed"
        }

        local min_buff_duration = 60
        local max_buff_duration = 3600

        if ctx.data.constants and ctx.data.constants.combat then
            local cc = ctx.data.constants.combat
            min_buff_duration = cc.min_buff_duration or 60
            max_buff_duration = cc.max_buff_duration or 3600
        end

        local target = args.target or ctx.gen.character_name()
        -- Self-buff 40% of the time
        local source
        if ctx.random.float() < 0.4 then
            source = target
        else
            source = ctx.gen.character_name()
        end

        local stacks = 1
        if ctx.random.float() < 0.2 then
            stacks = ctx.random.int(1, 5)
        end

        return {
            target = target,
            source = source,
            buff_name = ctx.random.choice(buffs),
            buff_id = ctx.random.int(1000, 99999),
            duration = ctx.random.int(min_buff_duration, max_buff_duration),
            stacks = stacks
        }
    end
}
