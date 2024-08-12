
file = {}

function file.Exists(path)
    if (not path) then return false end
    return not (love.filesystem.getInfo(path) == nil)
end
