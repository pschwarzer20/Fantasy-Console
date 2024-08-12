
local game = {}

local player = {
    segments = {
        vector(5, 5),
        vector(4, 5),
        vector(3, 5),
    },
    direction = vector(1, 0)
}

local gridSize = 4
local food = nil
local score = 0
local gameOver = false
local lastUpdate = 0
local updateDelay = 0.2

function isColliding(a, b)
    return a.x == b.x and a.y == b.y
end

function spawnFood()
    food = vector(
        math.Random(2, (windowWidth / gridSize) - 2),
        math.Random(4, (windowHeight / gridSize) - 2)
    )

    local collisionResolved = false

    while (collisionResolved == false) do
        local resolved = true

        for _, segment in ipairs(player.segments) do
            if (isColliding(segment, food)) then
                resolved = false

                food = vector(
                    math.Random(2, (windowWidth / gridSize) - 2),
                    math.Random(4, (windowHeight / gridSize) - 2)
                )

                break
            end
        end

        if (resolved) then
            collisionResolved = true
        end
    end
end

function setupGame()
    player = {
        segments = {
            vector(5, 5),
            vector(4, 5),
            vector(3, 5),
        },
        direction = vector(1, 0)
    }
    score = 0
    lastUpdate = 0
    gameOver = false

    spawnFood()
end


-- Interface Functions
function game.Load()
    setupGame()
end

function game.Update(dt)
    if (gameOver) then
        if (input.KeyPressed("return")) then
            setupGame()
        end
    else
        -- Get the input before the next update
        if (input.KeyPressed("up")) and player.direction.y == 0 then
            player.direction = vector(0, -1)
        elseif (input.KeyPressed("down")) and player.direction.y == 0 then
            player.direction = vector(0, 1)
        elseif (input.KeyPressed("left")) and player.direction.x == 0 then
            player.direction = vector(-1, 0)
        elseif (input.KeyPressed("right")) and player.direction.x == 0 then
            player.direction = vector(1, 0)
        end

        if (lastUpdate > CurTime()) then return end
        lastUpdate = CurTime() + updateDelay

        -- Create a new head
        local oldHead = player.segments[1]
        local newHead = vector(
            oldHead.x + player.direction.x,
            oldHead.y + player.direction.y
        )

        -- Check if the new head collided with any segments
        for _, segment in ipairs(player.segments) do
            if (isColliding(newHead, segment)) then
                gameOver = true
                return
            end
        end

        -- Check if we collided with any walls
        if (
            (newHead.x < 0 or newHead.x > ((windowWidth / gridSize) - 1)) or
            (newHead.y < 0 or newHead.y > ((windowHeight / gridSize) - 1))
        ) then
            gameOver = true
            return
        end

        -- Finally add our new head to the segments
        table.insert(player.segments, 1, newHead)

        -- Remove last piece if we didn't eat anything
        if (isColliding(newHead, food)) then
            score = score + 1
            spawnFood()

            lastUpdate = 0 -- Force a game update so that the snake doesn't look frozen for a moment when it collides with the food
        else
            table.remove(player.segments)
        end

        -- Finally adjust the game speed based on our score
        updateDelay = math.max(0.05, 0.2 - (score * 0.01))
    end
end

function game.Draw()
    -- Draw player
    for _, segment in ipairs(player.segments) do
        render.DrawRect(segment.x * gridSize, segment.y * gridSize, gridSize, gridSize)
    end

    -- Draw food
    render.DrawRect(food.x * gridSize, food.y * gridSize, gridSize, gridSize)

    -- Draw UI
    render.DrawText("Score: " .. score, 2, 2)

    -- Draw game over message
    if gameOver then
        render.DrawText("Game Over", 2, 12)
        render.DrawText("Press ENTER to continue", 2, 22)
    end
end

return game
