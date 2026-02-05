-- GPG Verify Success Generator
-- Generates GPG signature verification success log entries

return {
    metadata = {
        name = "security.gpg_verify_success",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "GPG signature verified",
        text_template = "[{timestamp}] gpg[{pid}]: Good signature from \"{signer}\"",
        tags = {"gpg", "signature", "verify"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local signers = {
            "Ubuntu Archive Automatic Signing Key",
            "Debian Archive Automatic Signing Key",
            ctx.gen.player_name() .. " <" .. ctx.gen.player_name() .. "@example.com>"
        }

        return {
            pid = ctx.random.int(100, 32768),
            signer = ctx.random.choice(signers),
            key_id = ctx.gen.hex_string(16)
        }
    end
}
