local assets = require("src/utils/assets")
local constants = require("src/utils/constants")
local player = require("src/gamemodes/player")
local camera = require("lib/camera")

local game = {}

game.level = nil
game.ground = nil
game.player = nil
game.objectID = 0
game.objects = {}

function game.reset()
    if game.level then
        love.audio.stop(music[game.level.song])
        love.audio.play(music[game.level.song])
        game.player.x, game.player.y = 0, (camera.height - (constants.blockSize / 2))
        game.player.grounded = false
    end
end

function game.enter(previousState, selectedLevel, startX, startY)
    game.level = nil
    if selectedLevel then
        game.player = player()
        game.player:setMode(constants.modes.cube)

        if assets.loadLevel(selectedLevel) then
            game.reset()
            if startX and startY then
                game.player.x, game.player.y = startX, startY
                local songPos = math.max((startX / (constants.scrollSpeed * 60)), 0)
                music[game.level.song]:seek(songPos, "seconds")
            end
            return true
        end
    end
    -- failed ): go to menu as failsafe
    switchGameState("menu")
end

function game.exit()
    if game.level then
        love.audio.stop(music[game.level.song])
        game.level = nil
    end
    if game.player then
        game.player:destroy()
        game.player = nil
    end
    for _, object in pairs(game.objects) do
        object:destroy()
    end
    game.objects = {}
end

function game.update(deltaTime)
    game.player:update(deltaTime)

    local x, y = game.player.body:getPosition()
    local targetY = (math.max((camera.height - y) - 450, constants.blockSize / 2))

    camera.setPosition(x - (camera.width / 3), (camera.height - targetY) - ((camera.height / 3) * 2))

    for _, object in pairs(game.objects) do
        if object.update then
            object:update(deltaTime)
        end
    end
end

function game.draw() 
    love.graphics.setBackgroundColor(0, 0, 0.5)
    love.graphics.draw(sprites.gavin, camera.x, camera.y, 0, (camera.width / sprites.gavin:getWidth()), (camera.width / sprites.gavin:getHeight()))
    do -- Draw level stuff
        game.player:draw()
        for _, object in pairs(game.objects) do
            if object.draw then
                object:draw()
            end
        end
    end
    love.graphics.draw(sprites.floorLine, camera.x + (camera.width / 2), camera.height, 0, 1, 1, sprites.floorLine:getWidth() / 2, sprites.floorLine:getHeight())
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle("fill", camera.x, camera.height, camera.width, camera.height)
    love.graphics.setColor(1, 1, 1, 1)
    -- Draw UI
    camera.reset()
    love.graphics.print("Hello!", 200, 300)
end

function game.keypressed(key)
    if key == "space" or key == "up" or key == "w" then
        for _, object in pairs(gameState.objects) do
            if object.onJump then
                object:onJump()
            end
        end

        game.player.jumping = true
    end
    if key == "tab" then
        switchGameState("editor", "Level Editor")
    end
end

function game.keyreleased(key)
    if key == "space" or key == "up" or key == "w" then
        game.player.jumping = false
    end
end

return game