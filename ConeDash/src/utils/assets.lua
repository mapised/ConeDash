local constants = require("src/utils/constants")
local objects = require("src/utils/objects")
local assets = {}

assets.modes = {
    [constants.modes.cube] = require("src/gamemodes/cube"),
    [constants.modes.wave] = require("src/gamemodes/wave"),
    [constants.modes.ship] = require("src/gamemodes/ship")
}

assets.objectTypes = {
    [constants.objectTypes.block] = require("src/objects/block"),
    [constants.objectTypes.spike] = require("src/objects/spike"),
    [constants.objectTypes.orb] = require("src/objects/orb"),
    [constants.objectTypes.pad] = require("src/objects/pad"),
    [constants.objectTypes.portal] = require("src/objects/portal"),
}

assets.levels = {
    ["Level Editor"] = require("src/levels/leveleditor"),
    ["Wonderwall"] = require("src/levels/leveleditor"),
}

local function loadObjects(level)
    gameState.objectID = 0
    for _, objectData in pairs(level.objects) do
        assets.addObject(unpack(objectData))
    end
end 

function assets.addObject(objectID, ...)
    gameState.objectID = gameState.objectID + 1
    local objectData = objects[objectID]
    local objectType, objectArgs = objectData[2], objectData[3]

    local object = assets.objectTypes[objectType](gameState.objectID, objectArgs, ...)
    object.objectID = objectID
    
    gameState.objects[gameState.objectID] = object
end

function assets.loadLevel(levelName)
    if currentState == "game" or currentState == "editor" then
        local level = assets.levels[levelName]
        if level then
            gameState.level = level
            loadObjects(level)
            return true
        end
    end
    return false
end

return assets