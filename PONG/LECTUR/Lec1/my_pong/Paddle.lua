Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.score = 0
end

function Paddle:update(dt)
    if(self.y < 0 ) then
        self.y = math.max(0, self.y + dt * self.dy)
    else
        self.y = math.min(VIRTUAL_HEIGHT-self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:updateAI1(ball, dt)
    local myCenterY = self.y + self.height/2
    local ballCenterY = ball.y + ball.height/2

    if ball.dx >= 0 then
        self.dy = 0
    else     
        if ballCenterY > myCenterY then
            self.dy = PADDLE_SPEED
            --print("i need to go down")
        elseif ballCenterY < myCenterY then
            self.dy = -PADDLE_SPEED
            --print("i need to go up")
        else
            self.dy = 0
            --print("i need to stay put")
        end
    end

    if(self.y < 0 ) then
        self.y = math.max(0, self.y + dt * self.dy)
    else
        self.y = math.min(VIRTUAL_HEIGHT-self.height, self.y + self.dy * dt)
    end
        
end

function Paddle:updateAI2(ball, dt)
    local myCenterY = self.y + self.height/2
    local ballCenterY = ball.y + ball.height/2

    if ball.dx <= 0 then
        self.dy = 0
    else     
        if ballCenterY > myCenterY then
            self.dy = PADDLE_SPEED
            --print("i need to go down")
        elseif ballCenterY < myCenterY then
            self.dy = -PADDLE_SPEED
            --print("i need to go up")
        else
            self.dy = 0
            --print("i need to stay put")
        end
    end

    if(self.y < 0 ) then
        self.y = math.max(0, self.y + dt * self.dy)
    else
        self.y = math.min(VIRTUAL_HEIGHT-self.height, self.y + self.dy * dt)
    end
        
end