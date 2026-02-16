local physics = require("src/utils/physics")
local constants = require("src/utils/constants")

local function snapRotation(angle)
    local quarterTurn = math.pi / 2
    return math.floor(angle / quarterTurn + 0.5) * quarterTurn
end

local Object = require("lib/classic")
local Wave = Object:extend()

function Wave:new(self)
    self.trails = {}
    self.rotation, self.targetRotation = 0, 0
end

function Wave:jump()
    if self.grounded then
        self.grounded = false
    end
end

function Wave:update(scale, deltaTime)
    for index, trail in pairs(self.trails) do
        if (love.timer.getTime() - trail.time) > 1.5 then
            self.trails[index] = nil
        end
    end
    if self.lastX and self.lastY then
        table.insert(self.trails, {
            time = love.timer.getTime();
            start = {self.lastX, self.lastY};
            target = {self.x, self.y}
        })
    end
    if self.grounded then
        self.yVel = 0
        self.targetRotation = math.pi / 2
    else
        if self.jumping then
            self.yVel = (physics.scrollSpeed * self.gravity)
            self.targetRotation = math.pi / 4
        else
            self.yVel = (-physics.scrollSpeed * self.gravity)
            self.targetRotation = math.pi / 1.33
        end
    end
    self.rotation = self:lerp(self.rotation, self.targetRotation, deltaTime * 30)
    self.lastX, self.lastY = self.x, self.y
end

function Wave:draw()
    for _, trail in pairs(self.trails) do
        love.graphics.setLineWidth(12)
        love.graphics.setColor(1, 1, 1)
        love.graphics.line(trail.start[1], trail.start[2], trail.target[1], trail.target[2])
    end
    
    local width, height = ((constants.blockSize * 0.5) / sprites.cone:getWidth()), ((constants.blockSize * 0.5) / sprites.cone:getHeight())
    love.graphics.draw(sprites.cone, self.body:getX(), self.body:getY(), self.rotation, width, height, (sprites.cone:getWidth() / 2), (sprites.cone:getHeight() / 2))
end

function Wave:destroy()
    self = nil
end

return Wave