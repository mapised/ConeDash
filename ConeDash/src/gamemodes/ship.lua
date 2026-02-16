local constants = require("src/utils/constants")

local Object = require("lib/classic")
local Ship = Object:extend()

function Ship:new(self)
    self.rotation, self.targetRotation = 0, 0
end

function Ship:jump()
    if self.grounded then
        self.grounded = false
    end
end

function Ship:update(scale, deltaTime)
    if not self.grounded then
        local direction = self.jumping and 1 or -1
        self.yVel = self.yVel + (((constants.shipGravity * direction) * self.gravity) * scale)

        if self.yVel > constants.shipMaxVelocity then
            self.yVel = constants.shipMaxVelocity
        elseif self.yVel < -constants.shipTerminalVelocity then
            self.yVel = -constants.shipTerminalVelocity
        end
    end

    if self.xVel ~= 0 or self.yVel ~= 0 then
        self.targetRotation = math.atan2(self.xVel, self.yVel)
    end

    self.rotation = self:lerp(self.rotation, self.targetRotation, deltaTime * 20)
end

function Ship:draw()
    local width, height = ((constants.blockSize * 0.8) / sprites.cone:getWidth()), ((constants.blockSize * 0.8) / sprites.cone:getHeight())
    love.graphics.draw(sprites.cone, self.body:getX(), self.body:getY(), self.rotation, width, height, (sprites.cone:getWidth() / 2), (sprites.cone:getHeight() / 2))
end

function Ship:destroy()
    self = nil
end

return Ship