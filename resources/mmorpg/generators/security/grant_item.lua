-- Admin Grant Item Generator

return {
    metadata = {
        name = "admin.grant_item",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Item granted by admin",
        text_template = "[{timestamp}] GRANT_ITEM: {admin} gave {target} [{rarity}] {item_name} x{quantity}",
        tags = {"security", "admin", "item"},
        merge_groups = {"gm_actions"}
    },

    generate = function(ctx, args)
        local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary"}

        if ctx.data.items and ctx.data.items.rarities then
            rarities = {}
            for _, r in ipairs(ctx.data.items.rarities) do
                table.insert(rarities, r.id or r.name or r)
            end
            if #rarities == 0 then
                rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary"}
            end
        end

        local reasons = {"bug_compensation", "event_reward", "testing", "customer_support"}
        local admin_names = {"Alpha", "Beta", "Gamma", "Delta"}

        return {
            admin = "GM_" .. ctx.random.choice(admin_names),
            target = args.target or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = ctx.gen.item_name(),
            rarity = ctx.random.choice(rarities),
            quantity = ctx.random.int(1, 10),
            reason = ctx.random.choice(reasons)
        }
    end
}
