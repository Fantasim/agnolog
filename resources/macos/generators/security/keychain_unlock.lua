-- Security Keychain Unlock Generator
-- Generates keychain unlock log entries

return {
    metadata = {
        name = "security.keychain_unlock",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Keychain unlocked",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Keychain {keychain} unlocked",
        tags = {"security", "keychain", "unlock"},
        merge_groups = {"keychain_ops"}
    },

    generate = function(ctx, args)
        local keychains = ctx.data.security.keychain_items.keychains or {"login.keychain-db", "System.keychain"}

        return {
            process = "securityd",
            pid = ctx.random.int(50, 500),
            level = "Default",
            subsystem = "com.apple.securityd",
            category = "keychain",
            keychain = ctx.random.choice(keychains),
            user = ctx.random.choice(ctx.data.names.users or {"admin"}),
            method = ctx.random.choice({"password", "biometric", "auto"})
        }
    end
}
