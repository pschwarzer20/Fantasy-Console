
hook = {}

-- Adds a new hook to the specified event
function hook.Add(event, identifier, func)
    hook[event] = hook[event] or {}
    hook[event][identifier] = func
end

-- Removes a hook from the specified event
function hook.Remove(event, identifier)
    if hook[event] and hook[event][identifier] then
        hook[event][identifier] = nil
    end
end

-- Calls the hook for the specified event
function hook.Call(event, ...)
    local eventHooks = hook[event] or {}
    for k, func in pairs(eventHooks) do
        if (type(k) == "string") then
            func(...)
        else
            func(k, ...)
        end
    end
end
