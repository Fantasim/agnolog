-- Application DCOM Error Generator (Event ID 10005)
-- Generates DCOM service start error events

return {
    metadata = {
        name = "application.dcom_error",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "DCOM error",
        text_template = "Event Type: Error\nEvent Source: DCOM\nEvent Category: None\nEvent ID: 10005\nComputer: {computer}\nDescription:\nDCOM got error \"{error_message}\" attempting to start the service {service_name} with arguments \"{arguments}\" in order to run the server:\n{clsid}",
        tags = {"application", "com", "dcom", "error"},
        merge_groups = {"com_errors"}
    },

    generate = function(ctx, args)
        local error_modules = ctx.data.application and ctx.data.application.error_modules

        local error_messages = (error_modules and error_modules.error_messages) or {
            "The service cannot be started, either because it is disabled or because it has no enabled devices associated with it.",
            "Access is denied.",
            "The service did not respond to the start or control request in a timely fashion."
        }

        local service_names = (error_modules and error_modules.com_services) or {
            "EventSystem",
            "SENS",
            "COMSysApp"
        }

        return {
            computer = ctx.gen.windows_computer(),
            error_message = ctx.random.choice(error_messages),
            service_name = ctx.random.choice(service_names),
            arguments = "",
            clsid = ctx.gen.guid()
        }
    end
}
