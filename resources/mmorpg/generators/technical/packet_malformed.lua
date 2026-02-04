-- Technical Packet Malformed Generator

return {
    metadata = {
        name = "technical.packet_malformed",
        category = "TECHNICAL",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Malformed packet received",
        text_template = "[{timestamp}] PKT_BAD: Malformed {packet_type} from {client} ({reason})",
        tags = {"technical", "network", "error"},
        merge_groups = {"packets"}
    },

    generate = function(ctx, args)
        local packet_types = {
            "AUTH", "MOVE", "CHAT", "COMBAT", "INVENTORY", "TRADE",
            "QUEST", "GUILD", "PARTY", "SPELL", "ITEM", "NPC"
        }

        local reasons = {
            "invalid_header", "checksum_mismatch", "invalid_size",
            "unknown_opcode", "truncated", "encryption_error",
            "invalid_sequence", "protocol_violation"
        }

        local packet_size_max = 4096

        if ctx.data.constants and ctx.data.constants.network then
            local nc = ctx.data.constants.network
            packet_types = nc.packet_types or packet_types
            packet_size_max = nc.packet_size_max or 4096
        end

        local actions = {"dropped", "logged", "flagged"}

        return {
            packet_type = ctx.random.choice(packet_types),
            client = ctx.gen.ip_address() .. ":" .. ctx.random.int(1024, 65535),
            reason = ctx.random.choice(reasons),
            raw_size = ctx.random.int(1, packet_size_max),
            action = ctx.random.choice(actions)
        }
    end
}
