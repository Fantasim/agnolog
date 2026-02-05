-- SSH Login Success Generator
-- Generates successful SSH login log entries

return {
    metadata = {
        name = "auth.ssh_login_success",
        category = "AUTH",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Successful SSH login",
        text_template = "[{timestamp}] sshd[{pid}]: Accepted {method} for {user} from {ip} port {port} ssh2",
        tags = {"auth", "ssh", "session"},
        merge_groups = {"sessions"}
    },

    generate = function(ctx, args)
        local auth_methods = ctx.data.users.authentication.auth_methods or {"password", "publickey"}
        local system_users = ctx.data.users.user_accounts.system_users or {"root"}

        local user
        if ctx.random.float(0, 1) < 0.8 then
            user = ctx.gen.username()
        else
            user = ctx.random.choice(system_users)
        end

        return {
            user = user,
            method = ctx.random.choice(auth_methods),
            ip = ctx.gen.ip_address(),
            port = ctx.random.int(1024, 65535),
            pid = ctx.random.int(1000, 32768),
            session_id = ctx.gen.session_id()
        }
    end
}
