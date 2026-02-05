-- Engine Failover Generator
-- Generates log entries for matching engine failover events

return {
    metadata = {
        name = "system.engine_failover",
        category = "SYSTEM",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Matching engine failover event",
        text_template = "[{timestamp}] FAILOVER: primary={primary_engine} backup={backup_engine} reason={failover_reason} duration={failover_time_ms}ms",
        tags = {"system", "failover", "high_availability"},
        merge_groups = {"system_events"}
    },

    generate = function(ctx, args)
        return {
            primary_engine = "engine_" .. ctx.random.int(1, 4),
            backup_engine = "engine_" .. ctx.random.int(5, 8),
            failover_reason = ctx.random.choice({"HEARTBEAT_TIMEOUT", "CRASH", "MANUAL_SWITCHOVER"}),
            failover_time_ms = ctx.random.int(50, 500),
            orders_in_flight = ctx.random.int(0, 100),
            state_sync_time_ms = ctx.random.int(10, 100)
        }
    end
}
