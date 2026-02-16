local camera = {}
camera.width, camera.height = 1920, 1080
camera.x = 0
camera.y = 0
camera.scale = 0

function camera.resize()
    local width, height = love.graphics.getDimensions()
    camera.scale = math.min(
        width / camera.width,
        height / camera.height
    )
end

function camera.apply()
    love.graphics.push()
    -- Center the virtual screen
    local width, height = love.graphics.getDimensions()
    local offsetX = (width - camera.width * camera.scale) / 2
    local offsetY = (height - camera.height * camera.scale) / 2

    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(camera.scale)
    love.graphics.translate(-camera.x, -camera.y)
end

function camera.reset()
    love.graphics.pop()
end

function camera.setPosition(x, y)
    camera.x, camera.y = x, y
end 

function camera.getMousePosition()
    local mx, my = love.mouse.getPosition()
    local width, height = love.graphics.getDimensions()

    local offsetX = (width - camera.width * camera.scale) / 2
    local offsetY = (height - camera.height * camera.scale) / 2
    
    local worldX = (mx - offsetX) / camera.scale + camera.x
    local worldY = (my - offsetY) / camera.scale + camera.y

    return worldX, worldY
end

camera.resize()

return camera