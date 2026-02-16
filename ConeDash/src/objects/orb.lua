local constants = require("src/utils/constants")
local camera = require("lib/camera")

local Object = require("src/objects/object")
local Orb = Object:extend()

function Orb:new(id, args, x, y, rotation)
    Orb.super.new(self, id, args, x, y, rotation)
    self.type = args[2]
    if self.type == constants.orbTypes.jump then
        self.velocity = constants.jumpVelocity * args[3]
    end
end

function Orb:check()
    local player = gameState.player
    local distance = math.sqrt(((self.x - player.x) ^ 2) + ((self.y - player.y) ^ 2))

    if distance < constants.orbDistance then
        return true
    end

    return false
end

function Orb:jump()
    gameState.player.grounded = false
    if self.type == constants.orbTypes.jump then
        gameState.player.yVel = self.velocity
        gameState.player.y = gameState.player.y - 1
    else
        gameState.player.invincibilityFrames = 10
        gameState.player.gravity = -gameState.player.gravity
        if not self.body then -- this behavior only applies to orbs
            gameState.player.yVel = -constants.jumpVelocity * gameState.player.gravity
        end
    end
end

function Orb:onJump()
    if self:check() then
        self:jump()
    end
end

function Orb:draw()
    local width, height = ((constants.blockSize) / self.sprite:getWidth()), ((constants.blockSize) / self.sprite:getHeight())
    
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, width, height, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return Orb