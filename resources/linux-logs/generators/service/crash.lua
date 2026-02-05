-- Service Crash Generator
-- Generates service crash log entries

return {
    metadata = {
        name = "service.crash",
        category = "SERVICE",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Service crashed",
        text_template = "[{timestamp}] systemd[1]: {service}.service: Main process exited, code={code}, status={status}/{signal}",
        tags = {"service", "systemd", "crash"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local services = ctx.data.services.application_services.web_servers or {"nginx", "apache2"}
        local signals = ctx.data.constants.signals.common_signals or {"SIGSEGV", "SIGABRT", "SIGKILL"}

        return {
            service = ctx.random.choice(services),
            code = ctx.random.choice({"exited", "killed", "dumped"}),
            status = ctx.random.int(1, 255),
            signal = ctx.random.choice(signals)
        }
    end
}
