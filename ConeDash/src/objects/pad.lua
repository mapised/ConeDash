local constants = require("src/utils/constants")
local camera = require("lib/camera")

local Orb = require("src/objects/orb")
local Pad = Orb:extend()

function Pad:new(id, args, x, y, rotation)
    Pad.super.new(self, id, args, x, y, rotation)

    do
        self.body = love.physics.newBody(world, self.x, self.y, "static")
        self.shape = love.physics.newRectangleShape(constants.blockSize, constants.blockSize)
        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.body:setAngle(self.rotation)
        self.fixture:setUserData(id)
        self.fixture:setSensor(true)
    end
end

function Pad:enter()
    self:jump()
end

function Pad:draw()    
    local width, height = ((constants.blockSize) / self.sprite:getWidth()), ((constants.blockSize / 3) / self.sprite:getHeight())
    
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, width, height, self.sprite:getWidth() / 2, - self.sprite:getHeight() / 2)
end

function Pad:onJump()

end


return Pad