-- Postfix Bounced Generator
-- Generates mail bounced log entries

return {
    metadata = {
        name = "application.postfix_bounced",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Mail bounced",
        text_template = "[{timestamp}] postfix/smtp[{pid}]: {queue_id}: to=<{to}>, relay={relay}, delay={delay}s, status=bounced ({reason})",
        tags = {"mail", "postfix", "bounce"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local domains = ctx.data.network.hostnames.domains or {"example.com"}
        local reasons = {
            "User unknown",
            "Mailbox full",
            "Service unavailable",
            "Connection refused",
            "Host not found"
        }

        -- Build hostname from YAML data
        local prefixes = ctx.data.network.hostnames.prefixes or {"mail"}
        local suffixes = ctx.data.network.hostnames.suffixes or {"01"}
        local hostname = ctx.random.choice(prefixes) .. "-" .. ctx.random.choice(suffixes)

        return {
            pid = ctx.random.int(1000, 32768),
            queue_id = ctx.gen.hex_string(10),
            to = ctx.gen.player_name() .. "@" .. ctx.random.choice(domains),
            relay = hostname .. "[" .. ctx.gen.ip_address() .. "]:25",
            delay = string.format("%.2f", ctx.random.float(1.0, 30.0)),
            reason = ctx.random.choice(reasons)
        }
    end
}
