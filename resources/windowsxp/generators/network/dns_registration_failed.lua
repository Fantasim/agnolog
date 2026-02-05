-- Network DNS Registration Failed Generator (Event ID 5774)
-- Generates DNS registration failed events

return {
    metadata = {
        name = "network.dns_registration_failed",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "DNS registration failed",
        text_template = "Event Type: Warning\nEvent Source: NETLOGON\nEvent Category: None\nEvent ID: 5774\nComputer: {computer}\nDescription:\nRegistration of the DNS record '{dns_record}' failed with the following error:\n{error_message}",
        tags = {"network", "dns", "registration", "failed"},
        merge_groups = {"network_errors"}
    },

    generate = function(ctx, args)
        local computer = ctx.gen.windows_computer()
        local domain = ctx.gen.windows_domain()

        return {
            computer = computer,
            dns_record = computer .. "." .. domain:lower() .. ". 600 IN A " .. ctx.gen.ip_address(true),
            error_message = "DNS server failure."
        }
    end
}
