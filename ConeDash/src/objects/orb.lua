local camera = require("src/camera")
local constants = require("src/utils/constants")
local physics = require("src/utils/physics")

local Object = require("src/objects/object")
local Orb = Object:extend()

function Orb:new(id, args, x, y)
    Orb.super.new(self, id, args)
    self.velocity = physics.jumpVelocity * args[2]

    self.data = {x, y}
    self.x, self.y = x * constants.blockSize, camera.height - (y * constants.blockSize)
end

function Orb:check()
    local player = gameState.player
    local distance = math.sqrt(((self.x - player.x) ^ 2) + ((self.y - player.y) ^ 2))

    if distance < constants.orbDistance then
        return true
    end

    return false
end

function Orb:onJump()
    if self:check() then
        gameState.player.grounded = false
        gameState.player.yVel = self.velocity
    end
end

function Orb:draw()
    local width, height = ((constants.blockSize) / self.sprite:getWidth()), ((constants.blockSize) / self.sprite:getHeight())
    
    love.graphics.draw(self.sprite, self.x, self.y, 0, width, height, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return Orb