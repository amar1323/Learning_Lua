
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 400

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())
    starttime = 0
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })
    
    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    winFont =  love.graphics.newFont('font.ttf', 16)
    player1 = Paddle(VIRTUAL_WIDTH - 15, 30, 4, 20)
    player2 = Paddle(10, VIRTUAL_HEIGHT - 50, 4, 20)

    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    game_stat = 'start'

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
    }
    
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    starttime = starttime + dt
    if game_stat == 'serve' then
        ball.dy = math.random(-50,50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        elseif servingPlayer == 2 then
            ball.dx = -math.random(140, 200)
        end
    elseif game_stat == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x - 4
            if ball.dy < 0 then
                ball.dy = -math.random(50,150)
            else
                ball.dy = math.random(50, 150)
            end
            sounds.paddle_hit:play()
        elseif ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x + 5
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds.paddle_hit:play()
        end
        
        if ball.y <= 0  then
            ball.dy = -ball.dy
            ball.y = 0
            sounds.wall_hit:play()
        end

        if ball.y  >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds.wall_hit:play()
        end
        if ball.x > player1.x + player1.width then
            player2.score = player2.score + 1 
            game_stat = 'serve'
            servingPlayer = 2
            ball:reset()
            sounds.score:play()
        elseif ball.x +ball.width < player2.x then
            player1.score = player1.score + 1
            game_stat = 'serve'
            servingPlayer = 1
            ball:reset()
            sounds.score:play()
        end
    end
    
    --if love.keyboard.isDown('up') then
    --    player1.dy = -PADDLE_SPEED
    --elseif love.keyboard.isDown('down') then
    --    player1.dy  = PADDLE_SPEED
    --else
    --    player1.dy = 0
    --end
--
    --if love.keyboard.isDown('z') then
    --    player2.dy = -PADDLE_SPEED
    --elseif love.keyboard.isDown('s') then
    --    player2.dy = PADDLE_SPEED
    --else
    --    player2.dy = 0
    --end

    if game_stat == 'play' then
        ball:update(dt)
    end
    if player1.score == 10 then
        game_stat = 'win'
        winner = 1
    elseif player2.score == 10 then
        game_stat = 'win'
        winner =2
    end
    
    --player1:update(dt)
    --player2:update(dt)
    
    player1:updateAI2(ball, dt)
    player2:updateAI1(ball, dt)
  
end

function love.keypressed(key)
    if key == 'escape'  then
        love.event.quit()
    elseif key == 'enter' or key == 'return'then
        if game_stat == 'start' or game_stat == 'serve' then
            game_stat = 'play'
        elseif game_stat == 'win' then
            game_stat = 'serve'

            ball:reset()

            player1.score = 0
            player2.score = 0
            if winner == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end

        end
    end
end

function love.draw()
    push:apply('start')
    
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    if game_stat == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif game_stat == 'serve'  then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
        0, 10, VIRTUAL_WIDTH, 'center')
    elseif game_state == 'play' then
        -- no UI messages to display in play
    elseif game_stat == 'win' then
        love.graphics.setFont(winFont)
        love.graphics.printf('Player ' .. tostring(winner) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setFont(scoreFont)
    love.graphics.printf(tostring(player2.score) .. "    " ..tostring(player1.score), 0,40, VIRTUAL_WIDTH, 'center')

    player1:render()
    player2:render()

    ball:render()
    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

