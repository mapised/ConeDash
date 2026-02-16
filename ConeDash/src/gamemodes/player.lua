local constants = require("src/utils/constants")
local assets = require("src/utils/assets")
local camera = require("lib/camera")

local Object = require("lib/classic")
local Player = Object:extend()

function Player:new()
    self.mode = nil
    self.collisions = 0
    self.invincibilityFrames = 0
    self.x, self.y = 0, 0
    self.xVel, self.yVel = 0, 0

    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    self.shape = love.physics.newRectangleShape(constants.blockSize, constants.blockSize)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("player")
    self.fixture:setRestitution(0)
    self.fixture:setSensor(false)

    self.moveDirection = 1
    self.gravity = 1

    self.dead = false
    self.jumping = false
    self.grounded = true
end

function Player:lerp(a, b, t)
    return a + (b - a) * t
end

function Player:ground()
    self.grounded = true
    self.yVel = 0
end

function Player:jump()
    if self.mode then
        self.mode.jump(self)
    end
end

function Player:update(deltaTime)
    local scale = deltaTime * 60
    self.xVel = (constants.scrollSpeed * self.moveDirection)

    if self.invincibilityFrames > 0 then
        self.invincibilityFrames = self.invincibilityFrames - 1
    end
    if self.jumping then
        self:jump()
    end
    if self.mode then
        self.mode.update(self, scale, deltaTime)
    end

    self.x = self.x + (self.xVel * scale)
    self.y = self.y - (self.yVel * scale)

    if self.y > camera.height - (constants.blockSize / 2) then
        self.y = camera.height - (constants.blockSize / 2)
        self:ground()
    end
    self.body:setPosition(self.x, self.y)
    -- bodys refuse work unless i do this
    self.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:draw()
    if self.mode then
        self.mode.draw(self)
    end
end

function Player:setMode(mode)
    if mode ~= self.mode then
        if self.mode then
            self.mode:destroy()
        end
        self.mode = assets.modes[mode](self)
    end
end

function Player:die()
    if self.invincibilityFrames <= 0 then
        self.collisions = 0
        gameState.reset()
    end
end

function Player:destroy()
    self.body:destroy()
    self = nil
end

return Player