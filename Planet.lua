local Planet = {}
Planet.__index = Planet

Planet.TYPE_RED    = 0
Planet.TYPE_ORANGE = 1
Planet.TYPE_YELLOW = 2
Planet.TYPE_GREEN  = 3
Planet.TYPE_BLUE   = 4
Planet.TYPE_INDIGO = 5
Planet.TYPE_VIOLET = 6

---
-- Create new planet object
-- @param world
-- @param color
-- @param position
-- @param energy_type
--
function Planet:create(world, color, position, energy_type)

    if color == nil then
        color = colorDefault()
    end

    local obj = Entity:create({
        name        = "Planet",
        radius      = 200,
        color       = color,
        energy_type = energy_type
    })

    -- Set initial position
    obj:setPosition(position.x, position.y)

    -- Create body, shape and combine into fixture
    local body    = love.physics.newBody(world, obj.position.x, obj.position.y, "static")
    local shape   = love.physics.newCircleShape(obj.position.x, obj.position.y, obj.radius)
    local fixture = love.physics.newFixture(body, shape, 100)
    
    fixture:setUserData(obj)
    fixture:setFriction(0.8)
    fixture:setCategory(1)

    obj.fixture = fixture

    setmetatable(obj, self)

    ---
    -- Draw
    --
    function obj:draw()
        love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        local wx, wy = self.fixture:getBody():getWorldPoints(self.position.x, self.position.y);
        love.graphics.circle("fill", wx, wy, self.radius)
        colorDefaultApply()
    end

    ---
    -- Update
    -- @param dt
    --
    function obj:update(dt)
        self:setPosition(self:getBody():getX(), self:getBody():getY())
    end

    return obj
end

return Planet