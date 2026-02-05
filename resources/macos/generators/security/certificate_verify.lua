-- Security Certificate Verify Generator

return {
    metadata = {
        name = "security.certificate_verify",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Certificate verification",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Certificate verification {result} for {subject}",
        tags = {"security", "certificate", "trust"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local issuers = ctx.data.security.certificates.issuers or {"Apple Inc.", "DigiCert"}
        local result = ctx.random.float(0, 1) < 0.95 and "succeeded" or "failed"
        return {
            process = "trustd",
            pid = ctx.random.int(50, 500),
            level = result == "succeeded" and "Default" or "Error",
            subsystem = "com.apple.trustd",
            category = "certificate",
            result = result,
            subject = ctx.random.choice(issuers),
            error_code = result == "failed" and ctx.random.choice({-67808, -67809, -67810}) or 0
        }
    end
}
