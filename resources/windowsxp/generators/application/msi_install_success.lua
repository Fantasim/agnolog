-- Application MSI Install Success Generator (Event ID 1033)
-- Generates MSI installation completed successfully

return {
    metadata = {
        name = "application.msi_install_success",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "RARE",
        description = "MsiInstaller - Installation completed successfully",
        text_template = "Event Type: Information\nEvent Source: MsiInstaller\nEvent Category: None\nEvent ID: 1033\nComputer: {computer}\nDescription:\nWindows Installer installed the product. Product Name: {product_name}. Product Version: {product_version}. Product Language: {product_language}. Installation success or error status: {status}.",
        tags = {"application", "msi", "installer", "success"},
        merge_groups = {"msi_events"}
    },

    generate = function(ctx, args)
        local products = {
            "Microsoft Office 2003",
            "Adobe Reader",
            "Windows Media Player",
            "Windows Update",
            "Microsoft .NET Framework"
        }

        return {
            computer = ctx.gen.windows_computer(),
            product_name = ctx.random.choice(products),
            product_version = string.format("%d.%d.%d",
                ctx.random.int(1, 11),
                ctx.random.int(0, 5),
                ctx.random.int(0, 9999)),
            product_language = "1033",
            status = "0"
        }
    end
}
