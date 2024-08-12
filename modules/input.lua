
local input = {}
input.KeyPresses = {}

input.IsKeyDown = love.keyboard.isDown

function input.keypressed(key)
    if (not input.KeyPresses[key]) then
        input.KeyPresses[key] = key
    end
end

function input.Update()
    for key, time in pairs(input.KeyPresses) do
        local newTable = {}

        for k, v in pairs(input.KeyPresses) do
            if (not v == val) then
                newTable[k] = v
            end
        end

        input.KeyPresses = newTable
    end
end

--

function input.KeyPressed(key)
    return input.KeyPresses[key]
end

function input.SetWindowLock(bool)
    love.mouse.setGrabbed(bool)
end

return input
