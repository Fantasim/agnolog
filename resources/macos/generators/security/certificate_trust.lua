-- Security Certificate Trust Decision Generator

return {
    metadata = {
        name = "security.certificate_trust",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Certificate trust decision",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Trust {decision} for {issuer}",
        tags = {"security", "certificate", "trust"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local issuers = ctx.data.security.certificates.issuers or {"Apple Inc."}
        return {
            process = "trustd",
            pid = ctx.random.int(50, 500),
            level = "Default",
            subsystem = "com.apple.trustd",
            category = "trust",
            decision = ctx.random.choice({"granted", "denied", "pending"}),
            issuer = ctx.random.choice(issuers),
            cert_type = ctx.random.choice({"SSL/TLS", "Code Signing", "Root CA"})
        }
    end
}
