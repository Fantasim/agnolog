-- GPG Verify Failure Generator
-- Generates GPG signature verification failure log entries

return {
    metadata = {
        name = "security.gpg_verify_failure",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "GPG verification failed",
        text_template = "[{timestamp}] gpg[{pid}]: BAD signature from \"{signer}\"",
        tags = {"gpg", "signature", "verify", "failure"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(100, 32768),
            signer = ctx.gen.player_name() .. " <" .. ctx.gen.player_name() .. "@example.com>",
            reason = ctx.random.choice({"expired key", "untrusted key", "signature mismatch"})
        }
    end
}
