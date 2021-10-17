Pipe = Class {}

local pipeImage = love.graphics.newImage("pipe.png")

PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orient, y)
    self.width = pipeImage:getWidth()
    self.height = PIPE_HEIGHT

    self.x = VIRTUAL_WIDTH
    self.y = y

    self.orientation = orient
end

function Pipe:update(dt)
end

function Pipe:render()
    love.graphics.draw(
        pipeImage,
        self.x,
        (self.orientation == "top" and self.y + PIPE_HEIGHT or self.y),
        0,
        1,
        (self.orientation == "top" and -1 or 1)
    )
end
