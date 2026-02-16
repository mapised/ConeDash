local camera = require("src/camera")
local constants = require("src/utils/constants")
local physics = require("src/utils/physics")

local Object = require("src/objects/object")
local Pad = Object:extend()

function Pad:new(id, args, x, y)
    Pad.super.new(self, id, args)
    self.velocity = physics.jumpVelocity * args[2]

    self.data = {x, y}
    self.x, self.y = x * constants.blockSize, camera.height - (y * constants.blockSize)

    do
        self.body = love.physics.newBody(world, self.x, self.y, "static")
        self.shape = love.physics.newRectangleShape(constants.blockSize, constants.blockSize/3)
        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.fixture:setUserData(id)
        self.fixture:setSensor(true)
    end
end

function Pad:enter()
    gameState.player.grounded = false
    gameState.player.yVel = self.velocity
end

function Pad:draw()    
    local width, height = ((constants.blockSize) / self.sprite:getWidth()), ((constants.blockSize / 3) / self.sprite:getHeight())
    
    love.graphics.draw(self.sprite, self.x, self.y, 0, width, height, self.sprite:getWidth() / 2, - self.sprite:getHeight() / 2)
end

return Pad