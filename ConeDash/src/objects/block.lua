local camera = require("src/camera")
local constants = require("src/utils/constants")

local Object = require("src/objects/object")
local Block = Object:extend()

function Block:new(id, args, x, y)
    Block.super.new(self, id, args)
    self.width, self.height = args[2], args[3]

    self.data = {x, y}
    self.x, self.y = x * constants.blockSize, camera.height - (y * constants.blockSize)

    do
        self.body = love.physics.newBody(world, self.x, self.y, "static")
        self.shape = love.physics.newRectangleShape(self.width * constants.blockSize, self.height * constants.blockSize)
        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.fixture:setUserData(id)
        self.fixture:setSensor(true)
    end
end

function Block:enter()
    if (gameState.player.y) < self.y then
        gameState.player.y = self.y - ((self.height * constants.blockSize) / 2) - (constants.blockSize / 2) + 1
        gameState.player.collisions = gameState.player.collisions + 1
        gameState.player:ground()
    else
        gameState.player:die()
    end
end

function Block:exit()
    gameState.player.collisions = math.max(gameState.player.collisions - 1, 0)
    if gameState.player.collisions <= 0 then
        gameState.player.grounded = false
    end
end

function Block:draw()
    local width, height = (self.width * constants.blockSize) / self.sprite:getWidth(), (self.height * constants.blockSize) / self.sprite:getHeight()
    love.graphics.draw(self.sprite, self.x, self.y, 0, width, height, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return Block