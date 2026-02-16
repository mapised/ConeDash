local constants = require("src/utils/constants")

local function snapRotation(angle)
    local quarterTurn = math.pi / 2
    return math.floor(angle / quarterTurn + 0.5) * quarterTurn
end

local Object = require("lib/classic")
local Cube = Object:extend()

function Cube:new(self)
    self.rotation, self.targetRotation = 0, 0
end

function Cube:jump()
    if self.grounded then
        self.grounded = false
        self.yVel = constants.jumpVelocity * self.gravity
    end
end

function Cube:update(scale, deltaTime)
    if not self.grounded then
        self.targetRotation = self.rotation + ((constants.rotationSpeed * deltaTime) * self.gravity)
        self.yVel = self.yVel - ((constants.gravity * self.gravity) * scale)

        if self.yVel > constants.terminalVelocity then
            self.yVel = constants.terminalVelocity
        elseif self.yVel < -constants.terminalVelocity then
            self.yVel = -constants.terminalVelocity
        end
    else
        self.targetRotation = snapRotation(self.rotation)
    end

    self.rotation = self:lerp(self.rotation, self.targetRotation, deltaTime * 30)
end

function Cube:draw()
    local width, height = ((constants.blockSize * 1) / sprites.cone:getWidth()), ((constants.blockSize * 1) / sprites.cone:getHeight())
    love.graphics.draw(sprites.cone, self.body:getX(), self.body:getY(), self.rotation, width, height, (sprites.cone:getWidth() / 2), (sprites.cone:getHeight() / 2))
end

function Cube:destroy()
    self = nil
end

return Cube