Class = require "class"
push = require "push"

require "Bird"
require "PipePair"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

backgroundSPEED = -50
groundSPEED = -200
local lastY = -PIPE_HEIGHT + math.random(80) + 20

local background = love.graphics.newImage("background.png")
local ground = love.graphics.newImage("ground.png")
local backgroundX = 0
local groundX = 0

local bird = Bird("bird.png")
local pipePairs = {}

local timeSpawn = 0

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Fifty Bird")
    math.randomseed(os.time())

    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = true,
            vsync = true
        }
    )

    love.keyboard.keypressed = {}
end

function love.update(dt)
    backgroundX = backgroundX + backgroundSPEED * dt
    groundX = groundX + groundSPEED * dt
    if backgroundX <= -412 then
        backgroundX = 0
    end

    if groundX <= -412 then
        groundX = 0
    end

    bird:update(dt)

    timeSpawn = timeSpawn + dt
    if timeSpawn > 2. then
        local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y

        table.insert(pipePairs, PipePair(y))
        print("Added new pipe!")
        timeSpawn = 0.
    end

    for i, pipePair in pairs(pipePairs) do
        pipePair:update(dt)
    end

    for i, pipePair in pairs(pipePairs) do
        if pipePair.remove then
            table.remove(pipePairs, i)
        end
    end

    love.keyboard.keypressed = {}
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keypressed[key] then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    love.keyboard.keypressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()

    love.graphics.draw(background, backgroundX, 0)
    love.graphics.draw(ground, groundX, VIRTUAL_HEIGHT - 16)
    bird:render()

    for i, pipePair in pairs(pipePairs) do
        pipePair:render()
    end

    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end
