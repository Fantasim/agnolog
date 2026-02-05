-- Virus Detected Generator
-- Generates virus detection log entries

return {
    metadata = {
        name = "security.virus_detected",
        category = "SECURITY",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Virus detected",
        text_template = "[{timestamp}] clamd[{pid}]: {file}: {virus_name} FOUND",
        tags = {"antivirus", "security", "malware"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local virus_names = ctx.data.security.attack_patterns.virus_names or {"Trojan.Generic", "Linux.Malware.Agent"}

        return {
            pid = ctx.random.int(100, 32768),
            file = "/tmp/suspicious_" .. ctx.gen.hex_string(8),
            virus_name = ctx.random.choice(virus_names)
        }
    end
}
