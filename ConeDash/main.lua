local startup = require("startup")
local camera = require("lib/camera")

local gameStates = {
    ["game"] = require("src/game"),
    ["editor"] = require("src/editor"),
}

currentState = ""
gameState = nil

function switchGameState(state, ...)
    if gameStates[state] then
        local previousState = currentState
        if gameState ~= gameStates[state] then
            if gameState then
                gameState.exit()
            end
            gameState = gameStates[state]
            currentState = state
            gameState.enter(previousState, ...)
        end
    end
end

function love.load()
    love.graphics.setDefaultFilter("linear", "linear")
    love.window.setMode(camera.width / 2, camera.height / 2, {resizable = true})
    love.window.setIcon(love.image.newImageData("icon.png"))
    love.window.setTitle("Cone Dash")

    camera.resize()

    startup()
end

function love.update(deltaTime)
    if gameState then
        gameState.update(deltaTime)
    end
    world:update(deltaTime)
end

function love.draw()
    camera.apply()
    if gameState then
        gameState.draw()
    end
end

function love.mousepressed(...)
    if gameState.mousepressed then
        gameState.mousepressed(...)
    end
end

function love.keypressed(key)
    if gameState.keypressed then
        gameState.keypressed(key)
    end
end

function love.keyreleased(key)
    if gameState.keyreleased then
        gameState.keyreleased(key)
    end
end

function love.resize()
    camera.resize()
end

--
local lldebugger = require("lldebugger")

if arg[2] == "debug" then
    lldebugger.start()
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end