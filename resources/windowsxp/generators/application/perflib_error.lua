-- Application Perflib Error Generator (Event ID 1008)
-- Generates performance counter error

return {
    metadata = {
        name = "application.perflib_error",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Perflib - Performance counter error",
        text_template = "Event Type: Error\nEvent Source: Perflib\nEvent Category: None\nEvent ID: 1008\nComputer: {computer}\nDescription:\nThe Open Procedure for service \"{service}\" in DLL \"{dll}\" failed. Performance data for this service will not be available. Status code returned is DWORD {status_code}.",
        tags = {"application", "perflib", "performance", "error"},
        merge_groups = {"perflib_errors"}
    },

    generate = function(ctx, args)
        local services = {
            "MSSQL$SQLEXPRESS",
            "ASP.NET_2.0.50727",
            "W3SVC",
            "RemoteAccess",
            "TermService"
        }

        local dlls = {
            "C:\\WINDOWS\\system32\\sqlctr80.dll",
            "C:\\WINDOWS\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_perf.dll",
            "C:\\WINDOWS\\system32\\w3ctrs.dll",
            "C:\\WINDOWS\\system32\\rasctrs.dll"
        }

        return {
            computer = ctx.gen.windows_computer(),
            service = ctx.random.choice(services),
            dll = ctx.random.choice(dlls),
            status_code = ctx.random.choice({"0xC0000135", "0x800706BA", "0x80070002"})
        }
    end
}
