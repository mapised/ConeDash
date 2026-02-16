local physics = require("src/utils/physics")

sprites = {}
music = {}

local function loadAssets()
    -- misc
    sprites.gavin = love.graphics.newImage("assets/gavin.jpg")
    sprites.cube = love.graphics.newImage("assets/player/cube.png")
    sprites.cone = love.graphics.newImage("assets/player/cone.png")
    sprites.floorLine = love.graphics.newImage("assets/objects/floorLine_001.png")
    -- blocks
    sprites.block = love.graphics.newImage("assets/objects/square_01_001.png")
    sprites.slab = love.graphics.newImage("assets/objects/plank_01_001.png")
    -- spikes
    sprites.spike = love.graphics.newImage("assets/objects/spike_01_001.png")
    sprites.spike2 = love.graphics.newImage("assets/objects/spike_02_001.png")
    -- orbs
    sprites.yellowOrb = love.graphics.newImage("assets/objects/ring_01_001.png")
    sprites.redOrb = love.graphics.newImage("assets/objects/ring_02_001.png")
    sprites.pinkOrb = love.graphics.newImage("assets/objects/ring_03_001.png")
    -- pads
    sprites.yellowPad = love.graphics.newImage("assets/objects/bump_01_001.png")
    sprites.redPad = love.graphics.newImage("assets/objects/bump_02_001.png")
    sprites.pinkPad = love.graphics.newImage("assets/objects/bump_03_001.png")
    -- portals
    sprites.wavePortal = love.graphics.newImage("assets/objects/portal_13_front_001.png")
    sprites.cubePortal = love.graphics.newImage("assets/objects/portal_03_front_001.png")

    music.wonderwall = love.audio.newSource("assets/music/wonderwall.mp3", "stream")
end

return function()
    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(physics.beginContact, physics.endContact, physics.preSolve, physics.postSolve)
    
    loadAssets()

    switchGameState("editor","Level Editor")
end