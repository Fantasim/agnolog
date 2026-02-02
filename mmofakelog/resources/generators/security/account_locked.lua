-- Security Account Locked Generator

return {
    metadata = {
        name = "security.account_locked",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Account locked due to failed attempts",
        text_template = "[{timestamp}] ACCOUNT_LOCKED: {username} after {attempts} failed attempts (unlock: {unlock_time}min)",
        tags = {"security", "auth", "lock"}
    },

    generate = function(ctx, args)
        local unlock_times = {5, 15, 30, 60, 1440}
        local triggers = {"password_attempts", "suspicious_ip", "brute_force"}

        return {
            username = args.username or ctx.gen.player_name(),
            attempts = ctx.random.int(3, 10),
            unlock_time = ctx.random.choice(unlock_times),
            ip = ctx.gen.ip_address(),
            trigger = ctx.random.choice(triggers)
        }
    end
}
