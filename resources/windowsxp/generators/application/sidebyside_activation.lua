-- Application SideBySide Activation Error Generator (Event ID 59)
-- Generates SideBySide activation context generation failed

return {
    metadata = {
        name = "application.sidebyside_activation",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "RARE",
        description = "SideBySide - Activation context generation failed",
        text_template = "Event Type: Error\nEvent Source: SideBySide\nEvent Category: None\nEvent ID: 59\nComputer: {computer}\nDescription:\nGenerate Activation Context failed for {application}. Reference error message: {error_message}.",
        tags = {"application", "sidebyside", "activation", "error"},
        merge_groups = {"sidebyside_errors"}
    },

    generate = function(ctx, args)
        local applications = {
            "C:\\Program Files\\Microsoft Office\\OFFICE11\\WINWORD.EXE",
            "C:\\Program Files\\Internet Explorer\\iexplore.exe",
            "C:\\Program Files\\Adobe\\Reader 9.0\\Reader\\AcroRd32.exe"
        }

        return {
            computer = ctx.gen.windows_computer(),
            application = ctx.random.choice(applications),
            error_message = "The referenced assembly is not installed on your system."
        }
    end
}
