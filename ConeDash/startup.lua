local constants = require("src/utils/constants")

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
    sprites.slab2 = love.graphics.newImage("assets/objects/plank_01_02_001.png")
    sprites.slab3 = love.graphics.newImage("assets/objects/plank_01_03_001.png")
    sprites.slabColor = love.graphics.newImage("assets/objects/plank_01_color_001.png")
    sprites.block2 = love.graphics.newImage("assets/objects/square_02_001.png")
    sprites.block3 = love.graphics.newImage("assets/objects/square_03_001.png")
    sprites.block4 = love.graphics.newImage("assets/objects/square_04_001.png")
    sprites.block5 = love.graphics.newImage("assets/objects/square_05_001.png")
    sprites.block6 = love.graphics.newImage("assets/objects/square_06_001.png")
    sprites.block7 = love.graphics.newImage("assets/objects/square_07_001.png")
    sprites.block8 = love.graphics.newImage("assets/objects/square_08_001.png")
    sprites.block9 = love.graphics.newImage("assets/objects/square_09_001.png")
    -- spikes
    sprites.spike = love.graphics.newImage("assets/objects/spike_01_001.png")
    sprites.spike2 = love.graphics.newImage("assets/objects/spike_02_001.png")
    -- orbs
    sprites.yellowOrb = love.graphics.newImage("assets/objects/ring_01_001.png")
    sprites.redOrb = love.graphics.newImage("assets/objects/ring_02_001.png")
    sprites.pinkOrb = love.graphics.newImage("assets/objects/ring_03_001.png")
    sprites.gravityOrb = love.graphics.newImage("assets/objects/gravring_01_001.png")
    -- pads
    sprites.yellowPad = love.graphics.newImage("assets/objects/bump_01_001.png")
    sprites.redPad = love.graphics.newImage("assets/objects/bump_02_001.png")
    sprites.pinkPad = love.graphics.newImage("assets/objects/bump_03_001.png")
    sprites.gravityPad = love.graphics.newImage("assets/objects/gravbump_01_001.png")
    -- portals
    sprites.wavePortal = love.graphics.newImage("assets/objects/portal_13_front_001.png")
    sprites.cubePortal = love.graphics.newImage("assets/objects/portal_03_front_001.png")
    sprites.shipPortal = love.graphics.newImage("assets/objects/portal_04_front_001.png")
    sprites.gravityPortalA = love.graphics.newImage("assets/objects/portal_01_front_001.png")
    sprites.gravityPortalB = love.graphics.newImage("assets/objects/portal_02_front_001.png")
    -- music
    music.wonderwall = love.audio.newSource("assets/music/wonderwall.mp3", "stream")
end

function love.run() -- custom run function ; update between frames
    if love.load then love.load() end

    local TICK_RATE = 120
    local TICK_DT = 1 / TICK_RATE

    local accumulator = 0
    local currentTime = love.timer.getTime()

    return function()
        -- Process events
        love.event.pump()
        for name, a, b, c, d in love.event.poll() do
            if name == "quit" then
                return a or 0
            end
            love.handlers[name](a, b, c, d)
        end

        -- Measure time
        local newTime = love.timer.getTime()
        local frameTime = newTime - currentTime
        currentTime = newTime

        accumulator = accumulator + frameTime

        -- Run as many logic ticks as needed BEFORE drawing
        while accumulator >= TICK_DT do
            if love.update then
                love.update(TICK_DT)
            end
            accumulator = accumulator - TICK_DT
        end

        -- Draw once
        if love.graphics.isActive() then
            love.graphics.clear()
            if love.draw then love.draw() end
            love.graphics.present()
        end

        love.timer.sleep(0.001)
    end
end


return function()
    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(constants.beginContact, constants.endContact)
    
    loadAssets()

    switchGameState("editor","Level Editor")
end
