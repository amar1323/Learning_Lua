PipePair = Class {}
require "Pipe"

local PIPE_GAP = 90
PIPE_SPEED = 60
function PipePair:init(y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.pipes = {
        ["top"] = Pipe("top", self.y),
        ["bottom"] = Pipe("bottom", self.y + PIPE_HEIGHT + PIPE_GAP)
    }

    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes["bottom"].x = self.x
        self.pipes["top"].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    self.pipes["top"]:render()
    self.pipes["bottom"]:render()
end
