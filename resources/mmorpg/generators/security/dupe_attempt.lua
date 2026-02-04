-- Security Dupe Attempt Generator

return {
    metadata = {
        name = "security.dupe_attempt",
        category = "SECURITY",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Item duplication attempt",
        text_template = "[{timestamp}] DUPE_ATTEMPT: {char_name} tried to duplicate {item_name}",
        tags = {"security", "exploit", "dupe"},
        merge_groups = {"security_violations"}
    },

    generate = function(ctx, args)
        local methods = {
            "trade_exploit", "mail_exploit", "guild_bank_exploit",
            "auction_exploit", "disconnect_timing"
        }

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_name = ctx.gen.item_name(),
            item_id = ctx.random.int(10000, 99999),
            method = ctx.random.choice(methods),
            action_taken = "permanent_ban",
            items_removed = ctx.random.int(0, 10)
        }
    end
}
