local constants = require("src/utils/constants")
local camera = require("lib/camera")

local BaseClass = require("lib/classic")
local Object = BaseClass:extend()

function Object:new(id, args, x, y, rotation)
    self.sprite = sprites[args[1]]

    self.data = {x, y, rotation}
    self.x, self.y = x * constants.blockSize, camera.height - (y * constants.blockSize)
    self.rotation = math.rad(rotation)
end

function Object:destroy()
    if self.body then
        self.body:destroy()
    end
    self = nil
end

function Object:getData() -- the editor uses this to turn objects into object data (for levels)
    if self.data then
        return self.data
    else
        print("object has no data ):")
        return {}
    end 
end

return Object