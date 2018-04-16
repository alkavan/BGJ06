Explosion = require "game/Explosion"

-- Projectile
local Projectile = {}
Projectile.__index = Projectile;

function Projectile:create(weapon)
    local world = weapon.ship:getBody():getWorld();

    local obj = Entity:create({
        name     = "Projectile",
        weapon   = weapon,
        speed    = 1,
        vx       = 200,
        vy       = 200,
        collided = false
    })

    local wx, wy = weapon:getPosition()
    obj:setPosition(wx, wy)

    -- Create body, shape and combine into fixture
    local body    = love.physics.newBody(world, wx, wy, "dynamic")
    local shape   = love.physics.newRectangleShape(3, 3)
    local fixture = love.physics.newFixture(body, shape, 10)

    local catagory   = weapon.ship.player.category
    local p_catagory = weapon.ship.player.category-10

--    print('PROJ_DEG: ', weapon.deg)
    body:setAngle(weapon.angle)
    body:setBullet(true)

    fixture:setUserData(obj)
    fixture:setCategory(catagory)
    fixture:setMask(catagory, p_catagory)
    fixture:setRestitution(0.1)
    fixture:setFriction(0.5)

    obj.fixture = fixture

    -- Load ship image
    obj.image  = love.graphics.newImage("asset/projectile1.png")

    -- Create animation properties
    obj.sprite = newAnimation(obj.image, 3, 3, 9.0)

    setmetatable(obj, self)

    ---
    -- Update
    -- @param dt
    -- @param world
    --
    function obj:update(dt, world)

        if self.collided == true then
            if self.explosion == nil then
                self.explosion = Explosion:create(self)
            end

            self.explosion:update(dt)
            return
        end

        local bx, by = self:getBody():getX(), self:getBody():getY()

        self:setPosition(bx, by)

        local angle = self:getBody():getAngle() - math.pi / 2
        local force = self.weapon.power

        local x, y, mass, inertia = self.fixture:getMassData()

        local fx = self.vx * ( force * math.cos(angle) / mass) * math.pow(dt, 2)
        local fy = self.vy * ( force * math.sin(angle) / mass) * math.pow(dt, 2)

        -- Apply force on projectile body
        self:getBody():applyForce(fx, fy)

        -- Update entity animation
        self.sprite:update(dt)
    end

    ---
    -- Draw
    --
    function obj:draw()
        colorDefaultApply()
        local x, y = self:getPosition()

        self.sprite:draw(x, y, self:getBody():getAngle())

        if self.explosion ~= nil then
            self.explosion:draw()
        end
    end

    ---
    -- Destory entity
    --
    function obj:destroy()
        self:getBody():destroy()
    end

    return obj
end

return Projectile
