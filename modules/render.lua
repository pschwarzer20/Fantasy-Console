
local render = {}

function render.DrawLine(x, y, w, h)
    love.graphics.line(x, y, x+w, y+h)
end

function render.DrawRect(x, y, w, h, line, rx, ry)
    love.graphics.rectangle(line and "line" or "fill", x, y, w, h, rx, ry)
end

function render.DrawPoly(vertices, line)
    love.graphics.polygon(line and "line" or "fill", vertices)
end

function render.DrawText(text, x, y, args)
    if (not args) then
        love.graphics.print(text, x, y)
    else
        love.graphics.print(text, x, y, unpack(args))
    end
end

return render
