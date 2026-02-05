-- Postfix Sent Generator
-- Generates mail sent via Postfix log entries

return {
    metadata = {
        name = "application.postfix_sent",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Mail sent via Postfix",
        text_template = "[{timestamp}] postfix/smtp[{pid}]: {queue_id}: to=<{to}>, relay={relay}, delay={delay}s, status=sent ({size} bytes queued)",
        tags = {"mail", "postfix"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local domains = ctx.data.network.hostnames.domains or {"example.com"}

        -- Build hostname from YAML data
        local prefixes = ctx.data.network.hostnames.prefixes or {"mail"}
        local suffixes = ctx.data.network.hostnames.suffixes or {"01"}
        local hostname = ctx.random.choice(prefixes) .. "-" .. ctx.random.choice(suffixes)

        return {
            pid = ctx.random.int(1000, 32768),
            queue_id = ctx.gen.hex_string(10),
            to = ctx.gen.player_name() .. "@" .. ctx.random.choice(domains),
            relay = hostname .. "[" .. ctx.gen.ip_address() .. "]:25",
            delay = string.format("%.2f", ctx.random.float(0.1, 5.0)),
            size = ctx.random.int(500, 50000)
        }
    end
}
