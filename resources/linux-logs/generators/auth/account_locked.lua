-- Account Locked Generator
-- Generates account lockout log entries

return {
    metadata = {
        name = "auth.account_locked",
        category = "AUTH",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Account locked",
        text_template = "[{timestamp}] faillock[{pid}]: Locking account {user} due to {attempts} failed login attempts",
        tags = {"auth", "security", "lockout"},
        merge_groups = {"auth_failures"}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(500, 32768),
            user = ctx.gen.player_name(),
            attempts = ctx.random.int(3, 10),
            from_ip = ctx.gen.ip_address()
        }
    end
}
