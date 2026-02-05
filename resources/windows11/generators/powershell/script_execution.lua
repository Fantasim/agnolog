-- PowerShell Event 4104: Script Block Logging
-- Critical for security monitoring of PowerShell activity

return {
    metadata = {
        name = "powershell.script_execution",
        category = "POWERSHELL",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "PowerShell script block execution",
        text_template = "[{timestamp}] Event {event_id}: Creating Scriptblock text ({script_length} characters): {script_preview}",
        tags = {"powershell", "execution", "script_block"},
        merge_groups = {"powershell_execution"}
    },

    generate = function(ctx, args)
        local cmdlets_data = ctx.data.powershell and ctx.data.powershell.cmdlets
        local cmdlets = {}

        -- Collect all cmdlets
        if cmdlets_data then
            if cmdlets_data.common then
                for _, cmd in ipairs(cmdlets_data.common) do
                    table.insert(cmdlets, cmd)
                end
            end
            if cmdlets_data.administrative then
                for _, cmd in ipairs(cmdlets_data.administrative) do
                    table.insert(cmdlets, cmd)
                end
            end
        end

        -- Fallback cmdlets
        if #cmdlets == 0 then
            cmdlets = {"Get-Process", "Get-Service", "Get-ChildItem"}
        end

        -- Generate realistic script content
        local script_patterns = {
            function() return ctx.random.choice(cmdlets) end,
            function()
                return string.format("%s -Name *", ctx.random.choice(cmdlets))
            end,
            function()
                return string.format("%s | %s", ctx.random.choice(cmdlets), ctx.random.choice(cmdlets))
            end,
            function()
                return string.format("$var = %s; Write-Output $var", ctx.random.choice(cmdlets))
            end
        }

        local script_generator = ctx.random.choice(script_patterns)
        local script_text = script_generator()
        local script_length = #script_text

        -- Generate IDs
        local script_block_id = ctx.gen.guid()
        local path_options = {
            "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\Modules\\",
            "C:\\Users\\" .. ctx.gen.windows_username() .. "\\Documents\\Scripts\\script.ps1",
            "prompt"
        }

        return {
            event_id = 4104,
            provider_name = "Microsoft-Windows-PowerShell",
            channel = "Microsoft-Windows-PowerShell/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Execute a Remote Command",
            keywords = "0x0",

            script_block_id = script_block_id,
            script_text = script_text,
            script_length = script_length,
            script_preview = script_text:sub(1, math.min(50, script_length)),
            path = ctx.random.choice(path_options),

            description = "Creating Scriptblock text"
        }
    end
}
