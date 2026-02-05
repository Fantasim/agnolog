-- Application SideBySide Dependency Error Generator (Event ID 32)
-- Generates SideBySide dependent assembly not found events

return {
    metadata = {
        name = "application.sidebyside_dependency",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "SideBySide - Dependent Assembly not found",
        text_template = "Event Type: Error\nEvent Source: SideBySide\nEvent Category: None\nEvent ID: 32\nComputer: {computer}\nDescription:\nDependent Assembly {assembly_name} could not be found and Last Error was {error_message}.",
        tags = {"application", "sidebyside", "assembly", "error"},
        merge_groups = {"sidebyside_errors"}
    },

    generate = function(ctx, args)
        local error_modules = ctx.data.application and ctx.data.application.error_modules

        local manifests = (error_modules and error_modules.sidebyside_manifests) or {
            "Microsoft.Windows.Common-Controls",
            "Microsoft.VC80.CRT",
            "Microsoft.VC90.CRT"
        }

        local versions = (error_modules and error_modules.sidebyside_versions) or {
            "6.0.0.0",
            "8.0.50727.42",
            "9.0.21022.8"
        }

        return {
            computer = ctx.gen.windows_computer(),
            assembly_name = ctx.random.choice(manifests) .. ",version=\"" .. ctx.random.choice(versions) .. "\"",
            error_message = "The system cannot find the file specified."
        }
    end
}
