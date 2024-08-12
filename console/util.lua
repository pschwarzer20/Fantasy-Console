
util = {}

function isnumber(value)
    return type(value) == "number"
end

function istable(value)
    return type(value) == "table"
end

function isstring(value)
    return type(value) == "string"
end

function prequire(...)
    local status, lib = pcall(require, ...)
    if(status) then return lib end

    return nil
end