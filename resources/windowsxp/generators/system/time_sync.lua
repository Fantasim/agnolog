-- System Time Sync Generator (W32Time)
-- Generates time synchronization success events

return {
    metadata = {
        name = "system.time_sync",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Time synchronization successful",
        text_template = "Event Type: Information\nEvent Source: W32Time\nEvent Category: None\nEvent ID: 35\nComputer: {computer}\nDescription:\nThe time service is now synchronizing the system time with the time source {time_source}.",
        tags = {"system", "time", "w32time", "sync"},
        merge_groups = {"system_events"}
    },

    generate = function(ctx, args)
        local time_sources = {
            "time.windows.com",
            "time.nist.gov",
            "pool.ntp.org",
            "time-a.nist.gov",
            "time-b.nist.gov",
            "time.google.com"
        }

        return {
            computer = ctx.gen.windows_computer(),
            time_source = ctx.random.choice(time_sources)
        }
    end
}
