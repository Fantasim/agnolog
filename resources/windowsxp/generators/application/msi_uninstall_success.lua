-- Application MSI Uninstall Success Generator (Event ID 1034)
-- Generates MSI removal completed successfully

return {
    metadata = {
        name = "application.msi_uninstall_success",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "RARE",
        description = "MsiInstaller - Removal completed successfully",
        text_template = "Event Type: Information\nEvent Source: MsiInstaller\nEvent Category: None\nEvent ID: 1034\nComputer: {computer}\nDescription:\nWindows Installer removed the product. Product Name: {product_name}. Product Version: {product_version}. Product Language: {product_language}. Removal success or error status: {status}.",
        tags = {"application", "msi", "installer", "uninstall"},
        merge_groups = {"msi_events"}
    },

    generate = function(ctx, args)
        local products = {
            "Microsoft Office 2003",
            "Adobe Reader 7.0",
            "Windows Media Player 10",
            "Older Version Software"
        }

        return {
            computer = ctx.gen.windows_computer(),
            product_name = ctx.random.choice(products),
            product_version = string.format("%d.%d.%d",
                ctx.random.int(1, 10),
                ctx.random.int(0, 5),
                ctx.random.int(0, 9999)),
            product_language = "1033",
            status = "0"
        }
    end
}
