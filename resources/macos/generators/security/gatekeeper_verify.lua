-- Security Gatekeeper Verification Generator

return {
    metadata = {
        name = "security.gatekeeper_verify",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Gatekeeper verification",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Gatekeeper {result} for {app}",
        tags = {"security", "gatekeeper", "codesign"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local apps = ctx.data.applications.system_apps or {"Safari", "Mail"}
        local result = ctx.random.float(0, 1) < 0.98 and "allowed" or "blocked"
        return {
            process = "syspolicyd",
            pid = ctx.random.int(50, 500),
            level = result == "allowed" and "Default" or "Error",
            subsystem = "com.apple.security.syspolicyd",
            category = "gatekeeper",
            result = result,
            app = ctx.random.choice(apps),
            developer_id = ctx.random.choice({"Apple Inc.", "Identified Developer"})
        }
    end
}
