local constants = {}

constants.blockSize = 80
constants.orbDistance = constants.blockSize * 2

constants.gravity = (1.6 / 60) * constants.blockSize;
constants.jumpVelocity = (22 / 60) * constants.blockSize;
constants.terminalVelocity = (30 / 60) * constants.blockSize;
constants.scrollSpeed = (10 / 60) * constants.blockSize;

constants.shipMaxVelocity = (9 / 60) * constants.blockSize;
constants.shipTerminalVelocity = (12 / 60) * constants.blockSize;
constants.shipGravity = (0.95 / 60) * constants.blockSize;

constants.rotationSpeed = math.pi * 4  -- 360° per second

constants.objectTypes = {
    ["block"] = 1;
    ["spike"] = 2;
    ["pad"] = 3;
    ["orb"] = 4;
    ["portal"] = 5;
}

constants.modes = {
    ["cube"] = 1;
    ["wave"] = 2;
    ["ship"] = 3;
}

constants.orbTypes = {
    ["jump"] = 1;
    ["gravity"] = 2;
}

constants.portalTypes = {
    ["mode"] = 1;
    ["gravity"] = 2;
}

function constants.beginContact(a, b, coll)
    if currentState == "game" then
        local dataA = a:getUserData()
	    local dataB = b:getUserData()

        if dataB == "player" then -- swap data
            dataA, dataB = dataB, dataA
        end
        
        if dataA == "player" then
            if gameState.objects[dataB] and gameState.objects[dataB].enter then
                if gameState.player then
                    gameState.objects[dataB]:enter()
                end
            end
        end
    end
end

function constants.endContact(a, b, coll)
    if currentState == "game" then
        local dataA = a:getUserData()
	    local dataB = b:getUserData()

        if dataB == "player" then -- swap data
            dataA, dataB = dataB, dataA
        end
        
        if dataA == "player" then
            if gameState.objects[dataB] and gameState.objects[dataB].exit then
                if gameState.player then
                    gameState.objects[dataB]:exit()
                end
            end
        end
    end
end

return constants