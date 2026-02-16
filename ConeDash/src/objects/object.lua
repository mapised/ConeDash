local BaseClass = require("lib/classic")
local Object = BaseClass:extend()

function Object:new(id, args)
    self.sprite = sprites[args[1]]
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