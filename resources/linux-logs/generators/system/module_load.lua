-- Kernel Module Load Generator
-- Generates kernel module loading log entries

return {
    metadata = {
        name = "system.module_load",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Kernel module loaded",
        text_template = "[{timestamp}] kernel: {module}: module loaded",
        tags = {"kernel", "module"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local modules = {
            "nvidia", "nouveau", "radeon", "amdgpu", "i915",
            "e1000", "e1000e", "igb", "ixgbe", "r8169",
            "iwlwifi", "ath9k", "rtl8192ce",
            "snd_hda_intel", "snd_hda_codec_realtek",
            "usbhid", "usb_storage", "btusb",
            "dm_crypt", "dm_mirror", "raid1", "raid5",
            "nf_conntrack", "iptable_filter", "ip_tables",
            "ext4", "xfs", "btrfs", "nfs", "cifs"
        }

        return {
            module = ctx.random.choice(modules),
            version = string.format("%d.%d.%d", ctx.random.int(1, 5), ctx.random.int(0, 20), ctx.random.int(0, 100))
        }
    end
}
