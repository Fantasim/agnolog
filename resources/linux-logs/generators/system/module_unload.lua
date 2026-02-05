-- Kernel Module Unload Generator
-- Generates kernel module unloading log entries

return {
    metadata = {
        name = "system.module_unload",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Kernel module unloaded",
        text_template = "[{timestamp}] kernel: {module}: module unloaded",
        tags = {"kernel", "module"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local modules = {
            "nvidia", "nouveau", "radeon", "amdgpu",
            "e1000", "e1000e", "igb",
            "iwlwifi", "ath9k",
            "snd_hda_intel",
            "usbhid", "usb_storage",
            "dm_crypt", "dm_mirror",
            "nf_conntrack",
            "nfs", "cifs"
        }

        return {
            module = ctx.random.choice(modules)
        }
    end
}
