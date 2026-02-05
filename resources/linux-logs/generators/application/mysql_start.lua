-- MySQL Start Generator
-- Generates MySQL start log entries

return {
    metadata = {
        name = "application.mysql_start",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "MySQL started",
        text_template = "[{timestamp}] mysqld[{pid}]: {version} started; port: {port} socket: {socket}",
        tags = {"mysql", "database"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local ports = ctx.data.network.protocols.common_ports or {}

        return {
            pid = ctx.random.int(1000, 32768),
            version = string.format("Ver 5.7.%d", ctx.random.int(20, 40)),
            port = ports.mysql or 3306,
            socket = "/var/run/mysqld/mysqld.sock"
        }
    end
}
