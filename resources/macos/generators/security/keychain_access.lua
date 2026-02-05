-- Security Keychain Access Generator
-- Generates keychain item access log entries

return {
    metadata = {
        name = "security.keychain_access",
        category = "SECURITY",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Keychain item accessed",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Application {app} accessed keychain item",
        tags = {"security", "keychain", "access"},
        merge_groups = {"keychain_ops"}
    },

    generate = function(ctx, args)
        local item_classes = ctx.data.security.keychain_items.item_classes or {"Internet password", "Application password"}

        return {
            process = "securityd",
            pid = ctx.random.int(50, 500),
            level = "Debug",
            subsystem = "com.apple.securityd",
            category = "keychain",
            app = ctx.random.choice(ctx.data.applications.system_apps or {"Safari", "Mail"}),
            item_class = ctx.random.choice(item_classes),
            allowed = ctx.random.float(0, 1) < 0.95
        }
    end
}
