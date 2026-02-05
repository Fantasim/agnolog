-- System Boot Start Generator (Event ID 6009)
-- Generates system boot information events

return {
    metadata = {
        name = "system.boot_start",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Microsoft Windows XP boot",
        text_template = "Event Type: Information\nEvent Source: EventLog\nEvent Category: None\nEvent ID: 6009\nComputer: {computer}\nDescription:\nMicrosoft (R) Windows (R) {version} {build_number} {service_pack} Multiprocessor Free.\n",
        tags = {"system", "boot", "lifecycle"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        local constants = ctx.data.constants and ctx.data.constants.system_constants
        local version = "5.1"
        local build_number = "2600"
        local service_pack = "Service Pack 3"

        if constants and constants.version then
            version = constants.version.nt_version or version
            if constants.version.build_numbers and #constants.version.build_numbers > 0 then
                build_number = ctx.random.choice(constants.version.build_numbers)
            end
            if constants.version.service_packs and #constants.version.service_packs > 0 then
                service_pack = ctx.random.choice(constants.version.service_packs)
            end
        end

        return {
            computer = ctx.gen.windows_computer(),
            version = version,
            build_number = build_number,
            service_pack = service_pack
        }
    end
}
