-- System Locale Changed Generator
-- Generates locale/language change log entries

return {
    metadata = {
        name = "system.locale_changed",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "System locale or language changed",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Locale changed to {locale}",
        tags = {"system", "locale", "language"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local locales = {
            "en_US",
            "en_GB",
            "fr_FR",
            "de_DE",
            "es_ES",
            "ja_JP",
            "zh_CN",
            "ko_KR"
        }

        return {
            process = "systempreferences",
            pid = ctx.random.int(1000, 65535),
            level = "Notice",
            subsystem = "com.apple.systempreferences",
            category = "locale",
            locale = ctx.random.choice(locales),
            language_code = ctx.random.choice({"en", "fr", "de", "es", "ja", "zh", "ko"}),
            region_code = ctx.random.choice({"US", "GB", "FR", "DE", "ES", "JP", "CN", "KR"})
        }
    end
}
