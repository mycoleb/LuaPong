-- Game variables
function love.load()
    -- Window settings
    love.window.setMode(800, 600)
    
    -- Global paddle speed
    paddleSpeed = 400
    
    -- Left paddle (Player 1)
    player1 = {
        x = 50,
        y = 300,
        width = 15,    -- Individual width for player 1
        height = 300,  -- Individual height for player 1 (bigger paddle)
        score = 0
    }
    
    -- Right paddle (Player 2)
    player2 = {
        x = 750 - 15,  -- Adjusted for paddle width
        y = 300,
        width = 15,    -- Individual width for player 2
        height = 90,   -- Individual height for player 2 (normal paddle)
        score = 0
    }
    
    -- Center paddles vertically
    player1.y = 300 - (player1.height/2)
    player2.y = 300 - (player2.height/2)
    
    -- Ball settings
    ball = {
        x = 400,
        y = 300,
        size = 10,
        speedX = 300,
        speedY = 300
    }
    
    -- Load font for scoring
    gameFont = love.graphics.newFont(40)
end

function love.update(dt)
    -- Player 1 controls (W/S keys)
    if love.keyboard.isDown('w') and player1.y > 0 then
        player1.y = player1.y - paddleSpeed * dt
    end
    if love.keyboard.isDown('s') and player1.y < 600 - player1.height then
        player1.y = player1.y + paddleSpeed * dt
    end
    
    -- Player 2 controls (Up/Down arrows)
    if love.keyboard.isDown('up') and player2.y > 0 then
        player2.y = player2.y - paddleSpeed * dt
    end
    if love.keyboard.isDown('down') and player2.y < 600 - player2.height then
        player2.y = player2.y + paddleSpeed * dt
    end
    
    -- Ball movement
    ball.x = ball.x + ball.speedX * dt
    ball.y = ball.y + ball.speedY * dt
    
    -- Ball collision with top and bottom walls
    if ball.y <= 0 or ball.y >= 600 - ball.size then
        ball.speedY = -ball.speedY
    end
    
    -- Ball collision with paddles
    -- Player 1 paddle
    if checkCollision(ball, player1) then
        ball.speedX = -ball.speedX * 1.1
        ball.x = player1.x + player1.width
    end
    
    -- Player 2 paddle
    if checkCollision(ball, player2) then
        ball.speedX = -ball.speedX * 1.1
        ball.x = player2.x - ball.size
    end
    
    -- Score points and reset ball
    if ball.x < 0 then
        player2.score = player2.score + 1
        resetBall('player2')
    end
    if ball.x > 800 then
        player1.score = player1.score + 1
        resetBall('player1')
    end
end

function love.draw()
    -- Draw paddles
    love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)
    
    -- Draw ball
    love.graphics.rectangle('fill', ball.x, ball.y, ball.size, ball.size)
    
    -- Draw center line
    for i = 0, 600, 30 do
        love.graphics.rectangle('fill', 395, i, 10, 15)
    end
    
    -- Draw scores
    love.graphics.setFont(gameFont)
    love.graphics.print(player1.score, 200, 50)
    love.graphics.print(player2.score, 600, 50)
end

-- Helper functions
function checkCollision(ball, paddle)
    return ball.x < paddle.x + paddle.width and
           ball.x + ball.size > paddle.x and
           ball.y < paddle.y + paddle.height and
           ball.y + ball.size > paddle.y
end

function resetBall(scorer)
    ball.x = 400
    ball.y = 300
    ball.speedX = 300
    ball.speedY = 300
    
    -- Set initial direction based on who scored
    if scorer == 'player2' then
        ball.speedX = 300
    else
        ball.speedX = -300
    end
end