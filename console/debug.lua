
debug = {}

local memoryData = {}
local lineData = {}
local mostMemory = 0
local enabled = false
local defaultFont

function debug.Load()
    defaultFont = love.graphics.getFont()
    memoryData = {}
    for i = 0, 30 do
        memoryData[i] = 0
    end
end

function debug.SetEnabled(bool)
    enabled = bool
end
function debug.GetEnabled()
    return enabled
end

local lastUpdate = 0
function debug.Update(dt)
    if (enabled) then
        if (lastUpdate < CurTime()) then
            lastUpdate = CurTime() + 0.5

            table.remove(memoryData, 1)
            table.insert(memoryData, math.Round(collectgarbage("count") / 1000, 2))

            local most = 0
            for i = 1, #memoryData do
                local v = memoryData[i]
                if v > most then
                    most = v
                end
            end
            mostMemory = most
        end
    end
end

local fontCache = love.graphics.getFont()
local fontHeight = fontCache:getHeight()
local y = 0
function debug.Draw()
    if (enabled) then
        y = fontHeight + fontHeight + fontHeight + fontHeight
        lineData = {}

        for i = 1, #memoryData do
            -- Build the X and Y of the point
            local x = 5 * (i - 1) + 2
            local y = 30 * (-memoryData[i] / mostMemory + 1) + 5

            -- Append it to the line
            table.insert(lineData, x)
            table.insert(lineData, y)
        end
        

        local oldFont = love.graphics.getFont()
        love.graphics.setFont(defaultFont)

        -- Draw the line
        love.graphics.setColor(fontColor())
        love.graphics.line(unpack(lineData))

        love.graphics.setColor(1, 1, 1)
        love.graphics.line(2, 35, 147, 35) -- Draw bottom line
        love.graphics.line(2, 35, 2, 2) -- Draw left line

        love.graphics.print("In Mb: " .. mostMemory .. " - " .. math.Round(collectgarbage("count") / 1000, 2), 1, 40 + fontHeight - fontHeight)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 1, 35 + fontHeight - fontHeight + fontHeight)
        love.graphics.print("CurTime: " .. CurTime(), 1, 30 + fontHeight - fontHeight + fontHeight + fontHeight)

        love.graphics.setFont(oldFont)
    end
end

function debug.DrawText(text)
    if (enabled) then
        local oldFont = love.graphics.getFont()
        love.graphics.setFont(defaultFont)

        y = y + fontHeight
        love.graphics.print(text, 1, y)

        love.graphics.setFont(oldFont)
    end
end
