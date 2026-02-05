-- PAM Success Generator
-- Generates successful PAM authentication log entries

return {
    metadata = {
        name = "auth.pam_success",
        category = "AUTH",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "PAM authentication OK",
        text_template = "[{timestamp}] {service}(pam_unix)[{pid}]: session opened for user {user} by (uid={uid})",
        tags = {"auth", "pam"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local pam_services = ctx.data.users.authentication.pam_services or {"sshd", "sudo", "login"}

        return {
            service = ctx.random.choice(pam_services),
            pid = ctx.random.int(500, 32768),
            user = ctx.gen.player_name(),
            uid = ctx.random.int(0, 60000)
        }
    end
}
