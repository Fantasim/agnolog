-- PAM Failure Generator
-- Generates failed PAM authentication log entries

return {
    metadata = {
        name = "auth.pam_failure",
        category = "AUTH",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "PAM authentication failed",
        text_template = "[{timestamp}] {service}(pam_unix)[{pid}]: authentication failure; logname={logname} uid={uid} euid={euid} tty={tty} ruser={ruser} rhost={rhost} user={user}",
        tags = {"auth", "pam", "failure"},
        merge_groups = {"auth_failures"}
    },

    generate = function(ctx, args)
        local pam_services = ctx.data.users.authentication.pam_services or {"sshd", "sudo", "login"}
        local ttys = {"ssh", "pts/0", "tty1", ""}

        return {
            service = ctx.random.choice(pam_services),
            pid = ctx.random.int(500, 32768),
            logname = "",
            uid = ctx.random.int(1000, 60000),
            euid = ctx.random.int(1000, 60000),
            tty = ctx.random.choice(ttys),
            ruser = "",
            rhost = ctx.gen.ip_address(),
            user = ctx.gen.player_name()
        }
    end
}
