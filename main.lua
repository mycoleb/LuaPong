-- I set up my game variables here, almost like I'm organizing my workspace before I begin a painting project.
function love.load()
    -- I configure the window to 800x600, like choosing the size of my canvas.
    love.window.setMode(800, 600)
    
    -- I give each paddle a speed, sort of like determining how fast each brush stroke will be.
    paddleSpeed = 400
    
    -- This is my left paddle (Player 1). 
    -- I imagine it as a tall tower on the left side, bigger and more imposing.
    player1 = {
        x = 50,       -- Anchored near the left edge, like a fort on the left border.
        y = 300,      -- Starting in the middle of the battlefield (screen).
        width = 15,   -- A specific width for Player 1's fortress wall.
        height = 300, -- It's taller, lower diffficulty like what you'd give to someone with no hand eye coordination.
        score = 0
    }
    
    -- This is my right paddle (Player 2). 
    -- It's shorter, makes the difficulty higher, like a smaller, more agile warrior.
    player2 = {
        x = 750 - 15, -- I position it just off the right edge, minus its width.
        y = 300,
        width = 15,   -- It's the same thickness but shorter in height.
        height = 90,  -- Higher difficulty, like an unprepared warrior defending against the enemy's attacks.
        score = 0
    }
    
    -- I want both paddles to sit exactly in the middle, 
    -- like balancing two seesaws at the same level.
    player1.y = 300 - (player1.height/2)
    player2.y = 300 - (player2.height/2)
    
    -- This is my ball, a tiny cube that zips across the screen like a hyperactive bee.
    ball = {
        x = 400,
        y = 300,
        size = 10,
        speedX = 300, -- It starts by heading right or left, determined later.
        speedY = 300  -- It's got equal vertical speed too, so it's eager to bounce around.
    }
    
    -- I load a font for the score display, kind of like putting a big scoreboard in a stadium.
    gameFont = love.graphics.newFont(40)
end

function love.update(dt)
    -- I check if Player 1 is moving up (by pressing 'W'), 
    -- drifting the left paddle upward like a crane lifting cargo.
    if love.keyboard.isDown('w') and player1.y > 0 then
        player1.y = player1.y - paddleSpeed * dt
    end
    -- I also check if Player 1 is moving down (by pressing 'S'), 
    -- letting that paddle drop like a drawbridge.
    if love.keyboard.isDown('s') and player1.y < 600 - player1.height then
        player1.y = player1.y + paddleSpeed * dt
    end
    
    -- Now I do the same for Player 2, using arrow keys as if controlling a separate machine.
    -- Press up to move the right paddle up.
    if love.keyboard.isDown('up') and player2.y > 0 then
        player2.y = player2.y - paddleSpeed * dt
    end
    -- Press down to move the right paddle down.
    if love.keyboard.isDown('down') and player2.y < 600 - player2.height then
        player2.y = player2.y + paddleSpeed * dt
    end
    
    -- The ball moves every frame, like a little meteor crossing the Pong galaxy.
    ball.x = ball.x + ball.speedX * dt
    ball.y = ball.y + ball.speedY * dt
    
    -- Check collision with the top and bottom edges—if it hits them, 
    -- I make it bounce back like a rubber ball hitting the floor or ceiling.
    if ball.y <= 0 or ball.y >= 600 - ball.size then
        ball.speedY = -ball.speedY
    end
    
    -- Now I check if the ball has collided with Player 1's paddle.
    if checkCollision(ball, player1) then
        -- If it does, I reverse its horizontal speed and give it a slight speed boost,
        -- like a racquet returning a tennis ball with a bit more oomph.
        ball.speedX = -ball.speedX * 1.1
        -- I also reposition it so it doesn't overlap the paddle, like pulling it out of quicksand.
        ball.x = player1.x + player1.width
    end
    
    -- Similarly, I check collision with Player 2's paddle.
    if checkCollision(ball, player2) then
        -- The bounce effect is the same, a quick reflection with extra speed,
        -- as though the paddle is giving the ball a high-five with a little extra force.
        ball.speedX = -ball.speedX * 1.1
        ball.x = player2.x - ball.size
    end
    
    -- If the ball goes off the left side, it means Player 2 scores a point, 
    -- like intercepting a missed shot in basketball.
    if ball.x < 0 then
        player2.score = player2.score + 1
        resetBall('player2')
    end
    
    -- If it goes off the right side, Player 1 gets the point, 
    -- like seizing an opportunity when the opponent's guard is down.
    if ball.x > 800 then
        player1.score = player1.score + 1
        resetBall('player1')
    end
end

function love.draw()
    -- Here I draw the paddles. I fill rectangles for each player's paddle, 
    -- like marking out the guardians of each side on the battlefield.
    love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)
    
    -- I draw the ball as a small rectangle (could've been a circle, but squares are simpler).
    -- Think of it as a tiny box zooming around the arena.
    love.graphics.rectangle('fill', ball.x, ball.y, ball.size, ball.size)
    
    -- I create a dashed line in the center, spaced out for style, 
    -- almost like the net in a tennis court or the middle line in a soccer field.
    for i = 0, 600, 30 do
        love.graphics.rectangle('fill', 395, i, 10, 15)
    end
    
    -- I set the font to my loaded font for the scores and print them on opposite sides,
    -- like two scoreboard counters beaming up top.
    love.graphics.setFont(gameFont)
    love.graphics.print(player1.score, 200, 50)
    love.graphics.print(player2.score, 600, 50)
end

-- This helper function checks if the ball and a paddle overlap,
-- like seeing if two puzzle pieces intersect in any way.
function checkCollision(ball, paddle)
    return ball.x < paddle.x + paddle.width and
           ball.x + ball.size > paddle.x and
           ball.y < paddle.y + paddle.height and
           ball.y + ball.size > paddle.y
end

-- When a player scores, I reset the ball to the center, 
-- like starting a new round of table tennis from the middle.
function resetBall(scorer)
    ball.x = 400
    ball.y = 300
    ball.speedX = 300
    ball.speedY = 300
    
    -- Depending on who scored, I launch the ball in a particular direction, 
    -- as though serving from that player's side.
    if scorer == 'player2' then
        ball.speedX = 300
    else
        ball.speedX = -300
    end
end
