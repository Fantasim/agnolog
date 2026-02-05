-- System Time Sync Failed Generator (W32Time)
-- Generates time synchronization failure events

return {
    metadata = {
        name = "system.time_sync_failed",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Time synchronization failed",
        text_template = "Event Type: Warning\nEvent Source: W32Time\nEvent Category: None\nEvent ID: 36\nComputer: {computer}\nDescription:\nThe time service has not synchronized the system time for {seconds} seconds because none of the time service providers provided a usable time stamp. The time service is no longer synchronized.",
        tags = {"system", "time", "w32time", "sync", "failed"},
        merge_groups = {"system_events"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            time_source = ctx.random.choice({"time.windows.com", "time.nist.gov", "pool.ntp.org"}),
            seconds = ctx.random.choice({3600, 7200, 86400})
        }
    end
}
