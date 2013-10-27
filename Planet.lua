-- Planet object
local Planet = {}
Planet.__index = Planet

Planet.TYPE_RED    = 0
Planet.TYPE_ORANGE = 1
Planet.TYPE_YELLOW = 2
Planet.TYPE_GREEN  = 3
Planet.TYPE_BLUE   = 4
Planet.TYPE_INDIGO = 5
Planet.TYPE_VIOLET = 6

function Planet:create(world, color, position, energy_type)

    if color == nil then
        color = colorDefault()
    end

    local obj = Entity:create({
        name  = "Planet",
        x     = position.x,
        y     = position.y,
        r     = 200,
        color = color,
        energy_type = energy_type
    })

    -- Create body, shape and combine into fixture
    local body    = love.physics.newBody(world, obj.x, obj.y, "static")
    local shape   = love.physics.newCircleShape(obj.x, obj.y, obj.r)
    local fixture = love.physics.newFixture(body, shape, 100)
    
    fixture:setUserData(obj)
    fixture:setFriction(0.8)
    fixture:setCategory(1)

    obj.fixture = fixture

    setmetatable(obj, self)

    --
    -- Methods
    --

    -- On draw
    function obj:draw()
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        local wx, wy = fixture:getBody():getWorldPoints(self.x, self.y);
        love.graphics.circle("fill", wx, wy, obj.r)
        colorDefaultApply()
        -- draw rect
        -- love.graphics.polygon("fill",fixture:getBody()
        --     :getWorldPoints(fixture:getShape():getPoints()))
    end

    -- On update
    function obj:update(dt)
        self.x = self:getBody():getX()
        self.y = self:getBody():getY()
    end

    return obj
end

return Planet