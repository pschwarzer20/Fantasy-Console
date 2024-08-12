
timer = {}
timer.Timers = {}

-- Purpose: Creates a timer that calls a function after a certain amount of time
function timer.Simple(time, func)
    local instance = {}
    instance.time = time
    instance.func = func
    instance.start = os.clock()
    local id = #timer.Timers + 1
    timer.Timers[id] = instance
    return id
end

function timer.Remove(id)
    table.remove(timer.Timers, id)
end

function timer.Exists(id)
    return timer.Timers[id]
end

function timer.Update(dt)
    for i, instance in pairs(timer.Timers) do
        if (os.clock() - instance.start >= instance.time) then
            instance.func()
            table.remove(timer.Timers, i)
        end
    end
end
