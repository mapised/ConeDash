local constants = require("src/utils/constants")
local camera = require("lib/camera")

local Object = require("src/objects/object")
local Portal = Object:extend()

function Portal:new(id, args, x, y, rotation)
    Portal.super.new(self, id, args, x, y, rotation)
    self.type = args[2]
    if self.type == constants.portalTypes.mode then
        self.mode = args[3]
    else
        self.direction = args[3]
    end

    do
        self.body = love.physics.newBody(world, self.x, self.y, "static")
        self.shape = love.physics.newRectangleShape(constants.blockSize / 3, constants.blockSize * 2.5)
        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.body:setAngle(self.rotation)
        self.fixture:setUserData(id)
        self.fixture:setSensor(true)
    end
end

function Portal:enter()
    if self.type == constants.portalTypes.mode then
        gameState.player:setMode(self.mode)
    else
        gameState.player.invincibilityFrames = 10
        gameState.player.yVel = 0
        gameState.player.grounded = false
        gameState.player.gravity = self.direction
    end
end

function Portal:draw()    
    local width, height = ((constants.blockSize) / self.sprite:getWidth()), ((constants.blockSize * 3) / self.sprite:getHeight())
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, width, height, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return Portal