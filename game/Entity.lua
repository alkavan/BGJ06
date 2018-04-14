---
-- Entity
-- a general game object
--
local Entity = {}
Entity.__index = Entity

---
-- Create new entity object
-- @param template
--
function Entity:create(template)
    local obj = template or Object:create({
        name     = "Entity",
        position = {x = 0, y = 0},
        fixture  = nil,
    })

    if obj.position == nil then
        obj.position = {x = 0, y = 0}
    end

    -- Assign entity to object
    setmetatable(obj, self)

    ---
    -- Get fixure body
    function obj:getBody()
        return self.fixture:getBody()
    end

    ---
    -- Get fixure shape
    function obj:getShape()
        return self.fixture:getShape()
    end

    ---
    -- Set entity position
    -- @param x
    -- @param y
    --
    function obj:setPosition(x, y)
        self.position.x = x
        self.position.y = y
    end

    function obj:getPosition()
        return self.position.x, self.position.y
    end

    return obj
end



return Entity
