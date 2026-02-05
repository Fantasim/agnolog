-- Application DCOM Timeout Generator (Event ID 10000)
-- Generates DCOM attempting to start service

return {
    metadata = {
        name = "application.dcom_timeout",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "DCOM attempting to start service",
        text_template = "Event Type: Warning\nEvent Source: DCOM\nEvent Category: None\nEvent ID: 10000\nComputer: {computer}\nDescription:\nUnable to start a DCOM Server: {clsid}. The error:\n\"{error_message}\"\nHappened while starting this command:\n{command}",
        tags = {"application", "dcom", "timeout", "error"},
        merge_groups = {"com_errors"}
    },

    generate = function(ctx, args)
        local commands = {
            "C:\\WINDOWS\\system32\\wbem\\wmiprvse.exe",
            "C:\\WINDOWS\\system32\\svchost.exe -k DcomLaunch",
            "C:\\WINDOWS\\system32\\msdtc.exe"
        }

        return {
            computer = ctx.gen.windows_computer(),
            clsid = ctx.gen.guid(),
            error_message = "The service did not respond to the start or control request in a timely fashion.",
            command = ctx.random.choice(commands)
        }
    end
}
