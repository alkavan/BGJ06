Weapon = require "Weapon"

-- Ship object
local Ship = {}
Ship.__index = Ship

function Ship:create(world, player)
    local obj = Entity:create({
        name          = "Ship",
        player        = player,
        density       = 10*GM,
        integrity     = 5000,
        integrity_max = 8000,
        integrity_cur = 5000,
        weapon        = nil
    })

    setmetatable(obj, self)

    -- Set initial position
    local px, py = player:getPosition()
    obj:setPosition(px, py)

    -- Create body, shape and combine into fixture
    local body    = love.physics.newBody(world, px, py, "dynamic")
    local shape   = love.physics.newCircleShape(16)
    local fixture = love.physics.newFixture(body, shape, obj.density)

    fixture:setUserData(obj)
    fixture:setCategory(2)
    fixture:setRestitution(0.3)
    fixture:setFriction(1.0)

    obj.fixture = fixture
    obj:getBody():setFixedRotation(true)

    -- Load ship image
    obj.image  = love.graphics.newImage("asset/ship1.png")

    -- Create animation properties
    obj.sprite = newAnimation(obj.image, 32, 32)

    -- Ship weapon
    obj.weapon = Weapon:create(16, obj)

    ---
    -- Draw
    --
    function obj:draw()
        colorDefaultApply()
        local x, y = self:getPosition()
        self.sprite:draw(x, y, self:getBody():getAngle(), 16)
        self.weapon:draw()
    end

    ---
    -- Update
    -- @param dt
    -- @param world
    --
    function obj:update(dt, world)
        local px, py = self.player:getPosition()
        self:setPosition(px, py)

        self.sprite:update(dt)
        self.weapon:update(dt, world)
        self.weapon:reload(dt)
    end

    return obj
end

return Ship
