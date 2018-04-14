Explosion = require "Explosion"

local Projectile = {}
Projectile.__index = Projectile;

function Projectile:create(weapon)
    local world = weapon.ship:getBody():getWorld();

    local obj = Entity:create({
        name     = "Projectile",
        weapon   = weapon,
        speed    = 1,
        vx       = 1200,
        vy       = 1200,
        collided = false
    })

    local wx, wy = weapon:getPosition()
    obj:setPosition(wx, wy)

    -- Create body, shape and combine into fixture
    local body    = love.physics.newBody(world, wx, wy, "dynamic")
    local shape   = love.physics.newRectangleShape(3, 3)
    local fixture = love.physics.newFixture(body, shape, 10)

    fixture:setUserData(obj)
    fixture:setCategory(3)
    fixture:setRestitution(0.1)
    fixture:setFriction(0.5)

    obj.fixture = fixture

    -- Load ship image
    obj.image  = love.graphics.newImage("asset/projectile1.png")

    -- Create animation properties
    obj.sprite = newAnimation(obj.image, 3, 3)

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

        -- TODO: use this for draw
        local dist_from_gun = distance(
            bx, by,
            self.weapon.ship:getBody():getX(), self.weapon.ship:getBody():getY()
        )

        -- Update entity animation
        self.sprite:update(dt)
    end

    ---
    -- Draw
    --
    function obj:draw()
        colorDefaultApply()
        local x, y = self:getPosition()
        self.sprite:draw(x, y, self:getBody():getAngle(), 1.5)
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

--    local angle = obj.parent.deg
--    local force = obj.parent.power*GM

--    local fx, fy
    -- TODO: create wind factor for fx (like GV*GM instead of 0)
    -- TODO: think, wait, why ind in space? is this for something else?
--    local x, y, mass, inertia = obj.fixture:getMassData()

    -- TODO: debug mode
--    print("x: "..x.." y: "..y.." mass: "..mass.." inertia: "..inertia)
--    fx = obj.vx * dt + 0.5 * ( ((force*math.sin( math.rad(angle) )) / mass ) - (GX*GM) ) * math.pow(dt, 2)
--    fy = obj.vy * dt + 0.5 * ( ((force*math.cos( math.rad(angle) )) / mass ) - (GY*GM) ) * math.pow(dt, 2)
--
--    obj:getBody():applyForce(fx, fy)

    return obj
end

return Projectile
