return {
    metadata = {
        name = "player.subscription_upgraded",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Player upgrades their subscription",
        text_template = "[{timestamp}] SUBSCRIPTION: {username} upgraded to {tier}",
        tags = {"player", "subscription", "premium"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        local tiers = {
            {name = "Gold", price = 5},
            {name = "Platinum", price = 14},
            {name = "Diamond", price = 49}
        }

        local tier = ctx.random.choice(tiers)

        return {
            username = ctx.gen.player_name(),
            previous_tier = ctx.random.choice({"Free", "Gold", "Platinum"}),
            new_tier = tier.name,
            price = tier.price,
            billing_cycle = ctx.random.choice({"monthly", "annual"}),
            payment_method = ctx.random.choice({"credit_card", "paypal", "apple_pay", "google_pay"})
        }
    end
}
