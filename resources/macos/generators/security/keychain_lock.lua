-- Security Keychain Lock Generator
-- Generates keychain lock log entries

return {
    metadata = {
        name = "security.keychain_lock",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Keychain locked",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Keychain {keychain} locked",
        tags = {"security", "keychain", "lock"},
        merge_groups = {"keychain_ops"}
    },

    generate = function(ctx, args)
        local keychains = ctx.data.security.keychain_items.keychains or {"login.keychain-db"}

        return {
            process = "securityd",
            pid = ctx.random.int(50, 500),
            level = "Default",
            subsystem = "com.apple.securityd",
            category = "keychain",
            keychain = ctx.random.choice(keychains),
            reason = ctx.random.choice({"timeout", "user logout", "manual lock"})
        }
    end
}
