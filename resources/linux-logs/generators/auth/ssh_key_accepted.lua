-- SSH Key Accepted Generator
-- Generates SSH public key authentication log entries

return {
    metadata = {
        name = "auth.ssh_key_accepted",
        category = "AUTH",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "SSH key accepted",
        text_template = "[{timestamp}] sshd[{pid}]: Accepted publickey for {user} from {ip} port {port} ssh2: {key_type} SHA256:{fingerprint}",
        tags = {"auth", "ssh", "publickey"},
        merge_groups = {"sessions"}
    },

    generate = function(ctx, args)
        local key_types = ctx.data.users.authentication.ssh_key_types or {"RSA", "ED25519", "ECDSA"}

        return {
            pid = ctx.random.int(1000, 32768),
            user = ctx.gen.player_name(),
            ip = ctx.gen.ip_address(),
            port = ctx.random.int(1024, 65535),
            key_type = ctx.random.choice(key_types),
            fingerprint = ctx.gen.hex_string(64)
        }
    end
}
