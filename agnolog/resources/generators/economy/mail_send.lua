-- Economy Mail Send Generator

return {
    metadata = {
        name = "economy.mail_send",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Mail with gold/items sent",
        text_template = "[{timestamp}] MAIL_GOLD: {from_char} sent {gold}g and {item_count} items to {to_char}",
        tags = {"economy", "mail", "player"}
    },

    generate = function(ctx, args)
        local has_gold = ctx.random.float() > 0.3
        local gold = has_gold and ctx.random.int(0, 10000) or 0

        local item_count = ctx.random.int(0, 5)
        local items = {}
        for i = 1, item_count do
            table.insert(items, ctx.gen.item_name())
        end

        local has_cod = ctx.random.float() < 0.1
        local cod_amount = has_cod and ctx.random.int(0, 5000) or 0

        return {
            from_char = args.from_char or ctx.gen.character_name(),
            to_char = args.to_char or ctx.gen.character_name(),
            gold = gold,
            item_count = item_count,
            items = items,
            cod_amount = cod_amount
        }
    end
}
