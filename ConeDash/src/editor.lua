local assets = require("src/utils/assets")
local constants = require("src/utils/constants")
local objects = require("src/utils/objects")
local camera = require("lib/camera")

local editor = {}
editor.objects = {}
editor.cameraSpeed = 1600
editor.increment = 0.5
editor.rotation = 0
editor.x, editor.y = 0, 0

editor.selection = {
    placing = 1,
    x = 0,
    y = 0,
    deleting = false,
}

local function snapToGrid(x, y)
    local x, y = x / constants.blockSize, (camera.height - y) / constants.blockSize
    return math.floor(x / editor.increment) * editor.increment + 0.5,
        math.floor(y / editor.increment) * editor.increment + 0.5
end

local function switchRotation()
    local rotation = editor.rotation
    rotation = rotation + 90
    if rotation >= 360 then
        rotation = 0
    end
    return rotation
end

local function switchIncrement()
    local increment = editor.increment
    if increment == 1 then
        increment = 0.5
    elseif increment == 0.5 then
        increment = 0.25
    elseif increment == 0.25 then
        increment = 1
    end
    return increment
end

local function switchPlacing(direction)
    local placing = editor.selection.placing + direction
    if placing > #objects then
        placing = direction
    elseif placing < 1 then
        placing = #objects + (direction + 1)
    end
    return placing
end

local function getObjects()
    local objects = {}
    for _, object in pairs(editor.objects) do
        table.insert(objects, {object.objectID, unpack(object:getData())})
    end
    return objects
end

local function saveToFile()
    print("Saving...")
    local objects = getObjects()
    local string = "return {\nsong = 'wonderwall',\nobjects = {\n"
    local lines = {}
    for i = 1, #objects do
        local row = objects[i]
        local values = {}

        for j = 1, #row do
            values[#values + 1] = tostring(row[j])
        end

        lines[#lines + 1] = "{" .. table.concat(values, ", ") .. "}"
    end

    string = string .. table.concat(lines, ", \n") .. "\n},\n}"
    local file = love.filesystem.newFile("savedLevel.lua", "w")
    file:write(string)
    file:close()
    print(love.filesystem.getSaveDirectory())
end

local function drawObject(objectID, x, y, rotation) -- pretends to draw a fake object
    local objectData = objects[objectID]
    local objectType, objectArgs = objectData[2], objectData[3]

    local object = {
        ["x"] = x;
        ["y"] = y;
        ["rotation"] = math.rad(rotation);
        sprite = sprites[objectArgs[1]];
    }

    if objectType == constants.objectTypes.block or objectType == constants.objectTypes.spike then
        object.width = objectArgs[2]
        object.height = objectArgs[3] 
    end

    assets.objectTypes[objectType].draw(object)
end

function editor.enter(previousState, selectedLevel)
    editor.level = nil
    if selectedLevel then
        assets.loadLevel(selectedLevel)
    end
end

function editor.exit()
    editor.level = nil
    for _, object in pairs(editor.objects) do
        object:destroy()
    end
    editor.objects = {}
end

function editor.update(deltaTime)
    -- update camera
    if love.keyboard.isDown("down") then
        editor.y = editor.y - (deltaTime * editor.cameraSpeed)
    elseif love.keyboard.isDown("up") then
        editor.y = editor.y + (deltaTime * editor.cameraSpeed)
    end
    if love.keyboard.isDown("left") then
        editor.x = editor.x - (deltaTime * editor.cameraSpeed)
    elseif love.keyboard.isDown("right") then
        editor.x = editor.x + (deltaTime * editor.cameraSpeed)
    end

    camera.setPosition(editor.x + (camera.width / 2), (camera.height - (editor.y)) - (camera.height / 2))

    --  update placement
    editor.selection.x, editor.selection.y = snapToGrid(camera.getMousePosition())

    for _, object in pairs(editor.objects) do
        if object.update then
            object:update(deltaTime)
        end
    end
end

function editor.draw()      
    for _, object in pairs(editor.objects) do
        if object.draw then
            object:draw()
        end
    end

    love.graphics.rectangle("fill", 0, camera.height, 10000 * constants.blockSize, constants.blockSize)

    -- draw selection box
    local width, height = constants.blockSize, constants.blockSize
    local selectX, selectY = (editor.selection.x * constants.blockSize) - width / 2, camera.height - ((editor.selection.y * constants.blockSize) + height / 2)
    if editor.selection.deleting then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle("fill", selectX, selectY, constants.blockSize, constants.blockSize)
    else
        love.graphics.setColor(1, 1, 1, 0.5)
        drawObject(editor.selection.placing, selectX + (constants.blockSize / 2), selectY + (constants.blockSize / 2), editor.rotation)
    end
    love.graphics.setColor(1, 1, 1, 1)

    -- draw selection
    local selection = objects[editor.selection.placing][1]
    local center = editor.x + camera.width
    if selection then
        love.graphics.setColor(1, 1, 1, 0.8)
        drawObject(editor.selection.placing, center, camera.y + constants.blockSize, 0)
        love.graphics.setColor(1, 1, 1, 0.4)
        drawObject(switchPlacing(1), center + ((constants.blockSize + 8) * 1), camera.y + constants.blockSize, 0)
        drawObject(switchPlacing(2), center + ((constants.blockSize + 8) * 2), camera.y + constants.blockSize, 0)
        drawObject(switchPlacing(3), center + ((constants.blockSize + 8) * 3), camera.y + constants.blockSize, 0)
        drawObject(switchPlacing(-1), center - ((constants.blockSize + 8) * 1), camera.y + constants.blockSize, 0)
        drawObject(switchPlacing(-2), center - ((constants.blockSize + 8) * 2), camera.y + constants.blockSize, 0)
        drawObject(switchPlacing(-3), center - ((constants.blockSize + 8) * 3), camera.y + constants.blockSize, 0)
        -- i vibecoded this but no one will look at this comment so it's ok
        love.graphics.polygon("fill",
            (center - (constants.blockSize * 5)) + (constants.blockSize * 0.5),
            (camera.y + constants.blockSize) - (constants.blockSize * 0.5),

            (center - (constants.blockSize * 5)),
            (camera.y + constants.blockSize),

            (center - (constants.blockSize * 5)) + (constants.blockSize * 0.5),
            (camera.y + constants.blockSize) + (constants.blockSize * 0.5)
        )

        love.graphics.polygon("fill",
            (center + (constants.blockSize * 5)) - (constants.blockSize * 0.5),
            (camera.y + constants.blockSize) - (constants.blockSize * 0.5),

            (center + (constants.blockSize * 5)),
            (camera.y + constants.blockSize),

            (center + (constants.blockSize * 5)) - (constants.blockSize * 0.5),
            (camera.y + constants.blockSize) + (constants.blockSize * 0.5)
        )
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- draw debug ui
    camera.reset()
    love.graphics.print(editor.x .. " " .. editor.y, 5, 5)
    love.graphics.print(editor.selection.x .. " " .. editor.selection.y, 5, 30)
    love.graphics.print(editor.increment, 5, 55)
    love.graphics.print(editor.rotation, 5, 80)
    love.graphics.print("Placing: " .. selection, 5, 105)
end

function editor.keypressed(key)
    if key == "tab" then -- Test mode
        assets.levels["Level Editor"].objects = getObjects()
        local x, y = nil, nil
        if love.keyboard.isDown("lshift") then
            x, y = editor.x + camera.width, camera.height - editor.y
        end
        switchGameState("game", "Level Editor", x, y)
    end

    if key == "q" then
        editor.selection.placing = switchPlacing(-1)
    elseif key == "e" then
        editor.selection.placing = switchPlacing(1)
    elseif key == "r" then
        editor.rotation = switchRotation()
    elseif key == "1" then
        editor.increment = switchIncrement()
    end

    if key == "o" then
        editor.x = editor.x - 100 * constants.blockSize
    elseif key == "p" then
        editor.x = editor.x + 100 * constants.blockSize
    end

    if key == "space" then
        editor.selection.deleting = not editor.selection.deleting
    end

    if key == "0" then
        saveToFile()
    end
end

function editor.mousepressed(x, y, button)
    if button == 1 then
        if not editor.selection.deleting then
            assets.addObject(editor.selection.placing, editor.selection.x, editor.selection.y, editor.rotation)
        else
            for index, object in pairs(editor.objects) do
                if object.data[1] == editor.selection.x and object.data[2] == editor.selection.y then
                    editor.objects[index] = nil
                    object:destroy()
                end
            end
        end
    elseif button == 2 then
        for index, object in pairs(editor.objects) do
            if object.data[1] == editor.selection.x and object.data[2] == editor.selection.y then
                editor.selection.placing = object.objectID
            end
        end
    end
end

return editor