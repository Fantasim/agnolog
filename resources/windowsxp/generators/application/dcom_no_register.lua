-- Application DCOM No Register Generator (Event ID 10010)
-- Generates DCOM server did not register

return {
    metadata = {
        name = "application.dcom_no_register",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "RARE",
        description = "DCOM server did not register",
        text_template = "Event Type: Error\nEvent Source: DCOM\nEvent Category: None\nEvent ID: 10010\nComputer: {computer}\nDescription:\nThe server {clsid} did not register with DCOM within the required timeout.",
        tags = {"application", "dcom", "register", "error"},
        merge_groups = {"com_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            clsid = ctx.gen.guid()
        }
    end
}
