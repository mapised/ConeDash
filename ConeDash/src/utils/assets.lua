local constants = require("src/utils/constants")
local assets = {}

assets.modes = {
    [constants.modes.cube] = require("src/gamemodes/cube"),
    [constants.modes.wave] = require("src/gamemodes/wave"),
}

assets.objectTypes = {
    [constants.objectTypes.block] = require("src/objects/block"),
    [constants.objectTypes.spike] = require("src/objects/spike"),
    [constants.objectTypes.orb] = require("src/objects/orb"),
    [constants.objectTypes.pad] = require("src/objects/pad"),
    [constants.objectTypes.portal] = require("src/objects/portal"),
}

assets.objects = {
    [1] = {
        "Block";
        constants.objectTypes.block;
        {"block", 1, 1};
    },
    [2] = {
        "Spike";
        constants.objectTypes.spike;
        {"spike", 1, 1};
    },
    [3] = {
        "Yellow Orb";
        constants.objectTypes.orb;
        {"yellowOrb", 0.984}
    },
    [4] = {
        "Pink Orb";
        constants.objectTypes.orb;
        {"pinkOrb", 0.706}
    },
    [5] = {
        "Red Orb";
        constants.objectTypes.orb;
        {"redOrb", 1.38}
    },
    [6] = {
        "Yellow Pad";
        constants.objectTypes.pad;
        {"yellowPad", 1.42}
    },
    [7] = {
        "Pink Pad";
        constants.objectTypes.pad;
        {"pinkPad", 0.922}
    },
    [8] = {
        "Red Pad";
        constants.objectTypes.pad;
        {"redPad", 1.88}
    },
    [9] = {
        "Cone";
        constants.objectTypes.spike;
        {"cone", 1, 1}
    },
    [10] = {
        "Slab";
        constants.objectTypes.block;
        {"slab", 1, 0.5}
    },
    [11] = {
        "Short Spike";
        constants.objectTypes.spike;
        {"spike2", 1, 0.5};
    },
    [12] = {
        "Wave Portal";
        constants.objectTypes.portal;
        {"wavePortal", constants.modes.wave}
    },
    [13] = {
        "Cube Portal";
        constants.objectTypes.portal;
        {"cubePortal", constants.modes.cube}
    }
}

assets.levels = {
    ["Level Editor"] = require("src/levels/leveleditor"),
    ["Wonderwall"] = require("src/levels/leveleditor"),
}

function assets.addObject(objectID, ...)
    gameState.objectID = gameState.objectID + 1
    local objectData = assets.objects[objectID]
    local objectType, objectArgs = objectData[2], objectData[3]

    local object = assets.objectTypes[objectType](gameState.objectID, objectArgs, ...)
    object.objectID = objectID
    
    gameState.objects[gameState.objectID] = object
end

local function loadObjects(level)
    gameState.objectID = 0
    for _, objectData in pairs(level.objects) do
        assets.addObject(unpack(objectData))
    end
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