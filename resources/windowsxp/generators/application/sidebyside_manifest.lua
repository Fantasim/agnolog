-- Application SideBySide Manifest Error Generator (Event ID 33)
-- Generates SideBySide assembly manifest parse error

return {
    metadata = {
        name = "application.sidebyside_manifest",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "RARE",
        description = "SideBySide - Assembly manifest parse error",
        text_template = "Event Type: Error\nEvent Source: SideBySide\nEvent Category: None\nEvent ID: 33\nComputer: {computer}\nDescription:\nGenerate Activation Context failed for {manifest_path}. Reference error message: {error_message}.",
        tags = {"application", "sidebyside", "manifest", "error"},
        merge_groups = {"sidebyside_errors"}
    },

    generate = function(ctx, args)
        local manifest_paths = {
            "C:\\WINDOWS\\WinSxS\\Manifests\\x86_Microsoft.Windows.Common-Controls_6595b64144ccf1df_6.0.2600.2180_x-ww_a84f1ff9.manifest",
            "C:\\Program Files\\Common Files\\Microsoft Shared\\VC\\msdia71.dll",
            "C:\\WINDOWS\\WinSxS\\x86_Microsoft.VC80.CRT_1fc8b3b9a1e18e3b_8.0.50727.42_x-ww_0de06acd\\Microsoft.VC80.CRT.manifest"
        }

        return {
            computer = ctx.gen.windows_computer(),
            manifest_path = ctx.random.choice(manifest_paths),
            error_message = "The operation completed successfully."
        }
    end
}
