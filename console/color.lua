
local COLOR = {}
COLOR.__index = COLOR

function Color(r, g, b, a)
    local color = setmetatable({}, COLOR)

    color.r = r and math.Clamp(r, 0, 255) or 0
    color.g = g and math.Clamp(g, 0, 255) or 0
    color.b = b and math.Clamp(b, 0, 255) or 0
    color.a = a and math.Clamp(a, 0, 255) or 255

    color.r, color.g, color.b, color.a = love.math.colorFromBytes(color.r, color.g, color.b, color.a)

    return color
end

function COLOR:__call()
    return self.r, self.g, self.b, self.a
end

function COLOR:__tostring()
    return string.format("Color(%f %f %f %f)", self.r, self.g, self.b, self.a)
end
