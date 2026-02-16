local constants = require("src/utils/constants")
local camera = require("lib/camera")

local Object = require("src/objects/object")
local Spike = Object:extend()

function Spike:new(id, args, x, y, rotation)
    Spike.super.new(self, id, args, x, y, rotation)
    self.width, self.height = args[2], args[3]

    do
        self.body = love.physics.newBody(world, self.x, self.y, "static")
        self.shape = love.physics.newRectangleShape((constants.blockSize * self.width)/3, (constants.blockSize * self.height)/3)
        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.body:setAngle(self.rotation)
        self.fixture:setUserData(id)
        self.fixture:setSensor(true)
    end
end

function Spike:enter()
    gameState.player:die()
end

function Spike:draw()
    local width, height = ((self.width * constants.blockSize) / self.sprite:getWidth()), ((self.height * constants.blockSize) / self.sprite:getHeight())
    
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, width, height, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return Spike