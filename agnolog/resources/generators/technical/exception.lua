-- Technical Exception Generator

return {
    metadata = {
        name = "technical.exception",
        category = "TECHNICAL",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Exception caught",
        text_template = "[{timestamp}] EXCEPTION: {exception_type}: {message} at {location}",
        tags = {"technical", "exception", "error"}
    },

    generate = function(ctx, args)
        local exceptions = {
            {type = "NullPointerException", message = "Object reference not set"},
            {type = "IndexOutOfBoundsException", message = "Index was outside the bounds of the array"},
            {type = "InvalidOperationException", message = "Operation is not valid due to the current state"},
            {type = "TimeoutException", message = "The operation has timed out"},
            {type = "IOException", message = "Unable to read data from the connection"},
            {type = "SQLException", message = "Error executing database query"},
            {type = "OutOfMemoryError", message = "Java heap space"},
            {type = "StackOverflowError", message = "Maximum recursion depth exceeded"}
        }

        local exc = ctx.random.choice(exceptions)

        local packages = {"world", "combat", "network", "db"}
        local classes = {"Handler", "Manager", "Service", "Controller"}
        local methods = {"process", "handle", "execute", "run"}

        local location = "com.game." .. ctx.random.choice(packages) .. "." ..
            ctx.random.choice(classes) .. "." .. ctx.random.choice(methods)

        return {
            exception_type = exc.type,
            message = exc.message,
            location = location,
            stack_trace_id = "trace_" .. ctx.random.int(100000, 999999),
            thread = "Worker-" .. ctx.random.int(1, 32)
        }
    end
}
