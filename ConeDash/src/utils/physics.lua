local physics = {}

physics.gravity = 2.86
physics.jumpVelocity = 39.85
physics.terminalVelocity = 61
physics.scrollSpeed = 20
physics.rotationSpeed = math.pi * 4  -- 360° per second

function physics.beginContact(a, b, coll)
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

function physics.endContact(a, b, coll)
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
-- empty functions
function physics.preSolve(a, b, coll)

end

function physics.postSolve(a, b, coll, normalimpulse, tangentimpulse)

end

return physics