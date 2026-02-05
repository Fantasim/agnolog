return {
    metadata = {
        name = "player.login",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Player logs into Chess.com",
        text_template = "[{timestamp}] LOGIN: {username} logged in from {country} ({ip_address})",
        tags = {"player", "login", "session"},
        merge_groups = {"sessions"}
    },
    generate = function(ctx, args)
        local countries = ctx.data.players.countries
        local country = ctx.random.choice(countries)

        return {
            username = ctx.gen.player_name(),
            session_id = ctx.gen.session_id(),
            ip_address = ctx.gen.ip_address(),
            country = country.code,
            country_name = country.name,
            device_type = ctx.random.choice({"desktop", "mobile", "tablet"}),
            browser = ctx.random.choice({"Chrome", "Firefox", "Safari", "Edge", "Mobile App"}),
            two_factor_used = ctx.random.float(0, 1) < 0.35
        }
    end
}
