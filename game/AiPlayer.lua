Ship = require "game/Ship"

-- Player object
local AiPlayer = {}
AiPlayer.__index = AiPlayer

---
-- Create new player object
-- @param world
-- @param position
--
function AiPlayer:create(world, position)

    if position == nil then
        position = {x = 0, y = 0 }
    end

    local obj = Entity:create({
        name          = "Player",
        position      = position,
        score         = 0,
        category      = 16,
        ship          = nil,
    })

    -- Create ship entity
    obj.ship = Ship:create(world, obj)

    setmetatable(obj, self)

    ---
    -- Draw
    --
    function obj:draw()
        self.ship:draw()
    end

    ---
    -- Update
    -- @param dt
    -- @param world
    -- @param cam
    --
    function obj:update(dt, world)

--        local sx, sy = self.ship:getBody():getWorldCenter()
--        self:setPosition(sx, sy)
--
--        -- Get mouse position
--        local mx, my = cam:mousepos()
--
--        local deltaX = mx - sx
--        local deltaY = my - sy
--
--        -- Calculate the angle
--        local d_radians = math.atan2(dt*deltaX, dt*deltaY)
--        local d_degrees = (d_radians + math.pi) * 360.0 / (2.0 * math.pi);
--
--        -- print("A: "..round(d_degrees, 1))
--        self.ship:getBody():setAngle(math.rad(360 - d_degrees))
        self.ship:update(dt, world)
    end

    return obj
end

return AiPlayer
