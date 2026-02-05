-- Application COM Bad Return Generator (Event ID 4609)
-- Generates COM+ Event System bad return code

return {
    metadata = {
        name = "application.com_bad_return",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "COM+ Event System bad return code",
        text_template = "Event Type: Warning\nEvent Source: COM+\nEvent Category: None\nEvent ID: 4609\nComputer: {computer}\nDescription:\nCOM+ Event System detected a bad return code during its internal processing. HRESULT was {hresult} from line {line} of {source_file}.",
        tags = {"application", "com", "error", "hresult"},
        merge_groups = {"com_errors"}
    },

    generate = function(ctx, args)
        local hresults = {
            "80070005", -- E_ACCESSDENIED
            "8007000E", -- E_OUTOFMEMORY
            "80004005", -- E_FAIL
            "80040154"  -- REGDB_E_CLASSNOTREG
        }

        return {
            computer = ctx.gen.windows_computer(),
            hresult = ctx.random.choice(hresults),
            line = ctx.random.int(100, 9999),
            source_file = "d:\\nt\\com\\complus\\src\\events\\eventsystemobj.cpp"
        }
    end
}
