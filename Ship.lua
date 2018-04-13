Weapon = require "Weapon"

-- Ship object
local Ship = {}
Ship.__index = Ship

function Ship:create(world, player)
    local obj = Entity:create({
        name          = "Ship",
        player        = player,
        x             = player.x,
        y             = player.y,
        density       = 10*GM,
        integrity     = 5000,
        integrity_max = 8000,
        integrity_cur = 5000,
        weapon        = nil
    })

    setmetatable(obj, self)

    -- Create body, shape and combine into fixture
    local body    = love.physics.newBody(world, player.x, player.y, "dynamic")
    local shape   = love.physics.newRectangleShape(32, 32)
    local fixture = love.physics.newFixture(body, shape, obj.density)

    fixture:setUserData(obj)
    fixture:setCategory(2)
    fixture:setRestitution(0.8)
    fixture:setFriction(1.0)

    obj.fixture = fixture
    obj:getBody():setFixedRotation(true)

    -- Load ship image
    obj.image  = love.graphics.newImage("asset/ship1.png")

    -- Create animation properties
    obj.frames    = Queue:create()
    obj.quad      = nil
    obj.quad_time = 0
    obj.interval  = 0.1

    -- Create sprite frames
    obj.frames:push(love.graphics.newQuad(0, 0,   32, 32, obj.image:getWidth(), obj.image:getHeight()))
    obj.frames:push(love.graphics.newQuad(0, 32,  32, 32, obj.image:getWidth(), obj.image:getHeight()))
    obj.frames:push(love.graphics.newQuad(0, 64,  32, 32, obj.image:getWidth(), obj.image:getHeight()))
    obj.frames:push(love.graphics.newQuad(0, 96,  32, 32, obj.image:getWidth(), obj.image:getHeight()))
    obj.frames:push(love.graphics.newQuad(0, 128, 32, 32, obj.image:getWidth(), obj.image:getHeight()))

    obj.weapon = Weapon:create(16, obj)
    --
    -- Methods
    --

    -- On draw
    function obj:draw()
        colorDefaultApply()
        love.graphics.draw(self.image, self.quad, self.x, self.y, self:getBody():getAngle(), 1, 1, 16, 16)
        self.weapon:draw()
    end

    -- On update
    function obj:update(dt, world)
        self.x = self.player.x
        self.y = self.player.y

        local now = love.timer.getTime()

        if (self.quad == nil) or (now - self.quad_time >= self.interval) then

            if self.quad ~= nil then
                self.frames:push(self.quad)
            end

            self.quad_time = now
            self.quad = self.frames:pop()
        end

        self.weapon:update(dt, world)
        self.weapon:reload(dt)
    end

    return obj
end

return Ship
