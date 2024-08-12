
local game = {}

local windowWidth, windowHeight = 160, 144

local player, computer
local playerHeight, playerWidth = 12, 2
local playerOffset = 6
local computerPosition
local movementModifier = 4

local ball, ballSize, ballVelocity

local computerScoreOffset

function setupGame()
    player = {
        position = (windowHeight / 2) - (playerHeight / 2),
        score = 0
    }
    computer = {
        position = (windowHeight / 2) - (playerHeight / 2),
        score = 0
    }

    ballSize = vector(2, 2)
    ball = vector((windowWidth / 2), (windowHeight / 2))
    ballVelocity = vector(0.35, 0.25)
    ballMoving = false

    computerScoreOffset = windowWidth - 2 - 8
    computerPosition = windowWidth - playerOffset - playerWidth -- windowHeight - playerOffset - playerWidth

    timer.Simple(1, function()
        ballMoving = true
    end)
end

function resetGame()
    ball = vector((windowWidth / 2), (windowHeight / 2))
    ballVelocity = vector(0.35, 0.25)
    ballMoving = false

    timer.Simple(1, function()
        ballMoving = true
    end)
end

function game.Load()
    setupGame()
end

function game.Update(dt)
    -- Player Input & Movement
    local direction = 0
    if (input.IsKeyDown("up")) then
        direction = 1
    elseif (input.IsKeyDown("down")) then
        direction = -1
    end

    -- If we gave an input, move the paddle
    if (direction ~= 0) then
        player.position = math.Clamp(player.position - (direction / movementModifier), 2, windowHeight-playerHeight-2)
    end

    -- Computer Movement
    if ball.y > computer.position + playerHeight / 2 then
        computer.position = math.Clamp(computer.position + (1 / movementModifier), 2, windowHeight-playerHeight-2)
    elseif ball.y < computer.position + playerHeight / 2 then
        computer.position = math.Clamp(computer.position - (1 / movementModifier), 2, windowHeight-playerHeight-2)
    end

    -- Only move the ball when the game is running
    if (ballMoving) then
        ball.x = ball.x + ballVelocity.x
        ball.y = ball.y + ballVelocity.y
    end

    -- Wall Collisions
    if (ball.x >= (windowWidth-1)) then
        setupGame()
        player.score = player.score + 1
    elseif (ball.x <= 0) then
        setupGame()
        computer.score = computer.score + 1
    end
    if (ball.y >= (windowHeight-1) or ball.y <= 0) then
        ballVelocity.x = 1 * ballVelocity.x
        ballVelocity.y = -1 * ballVelocity.y
    end

    -- Player Collision
    if ((ball.x >= playerOffset) and (ball.x <= (playerOffset + playerWidth)) and
        (ball.y >= (player.position - playerHeight)) and (ball.y <= (player.position + playerHeight))
        ) then
        ballVelocity.x = -1 * ballVelocity.x
        ballVelocity.y = 1 * ballVelocity.y
    end

    -- Computer Collision
    if ((ball.x >= computerPosition) and (ball.x <= (computerPosition + playerWidth)) and
        (ball.y >= (computer.position - playerHeight)) and (ball.y <= (computer.position + playerHeight))
        ) then
        ballVelocity.x = -1 * ballVelocity.x
        ballVelocity.y = 1 * ballVelocity.y
    end
end

function game.Draw()
    -- Draw Players
    render.DrawRect(playerOffset, player.position, playerWidth, playerHeight)
    render.DrawRect(computerPosition, computer.position, playerWidth, playerHeight)

    -- Draw Ball
    render.DrawRect(ball.x, ball.y, ballSize.x, ballSize.y)

    -- Draw UI
    render.DrawText(player.score, 2, 2)
    render.DrawText(computer.score, computerScoreOffset, 2)
end

return game
