-- Security Code Signature Verify Generator

return {
    metadata = {
        name = "security.code_signature_verify",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Code signature verification",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Code signature {result} for {binary}",
        tags = {"security", "codesign", "verification"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local processes = ctx.data.system.processes.system_processes or {"Safari", "Mail"}
        local result = ctx.random.float(0, 1) < 0.99 and "valid" or "invalid"
        return {
            process = "amfid",
            pid = ctx.random.int(50, 500),
            level = result == "valid" and "Default" or "Error",
            subsystem = "com.apple.security.amfi",
            category = "codesign",
            result = result,
            binary = "/System/Applications/" .. ctx.random.choice(processes) .. ".app",
            error_code = result == "invalid" and ctx.random.choice({-67808, -67062}) or 0
        }
    end
}
