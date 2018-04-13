-- GunBarrel
local Projectile = {}
Projectile.__index = Projectile;

function Projectile:create(weapon)
    local world = weapon.ship:getBody():getWorld();

    local obj = Entity:create({
        name    = "Projectile",
        weapon  = weapon,
        x       = weapon.x,
        y       = weapon.y,
        speed   = 1,
        vx      = 600,
        vy      = 600
    })

    setmetatable(obj, self)

    -- Create body, shape and combine into fixture
    local body    = love.physics.newBody(world, obj.x, obj.y, "dynamic")
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
    obj.frames    = Queue:create()
    obj.quad      = nil
    obj.quad_time = 0
    obj.interval  = 0.1

    -- Create sprite frames
    obj.frames:push(love.graphics.newQuad(0, 0, 3, 3, obj.image:getWidth(), obj.image:getHeight()))
    obj.frames:push(love.graphics.newQuad(3, 0, 3, 3, obj.image:getWidth(), obj.image:getHeight()))
    obj.frames:push(love.graphics.newQuad(6, 0, 3, 3, obj.image:getWidth(), obj.image:getHeight()))

    function obj:draw()
        colorDefaultApply()
        love.graphics.draw(self.image, self.quad, self.x, self.y, self:getBody():getAngle(), 1, 1, 1.5, 1.5)

--        love.graphics.setColor(0, 170, 170)
--        love.graphics.polygon("line", self:getBody():getWorldPoints(self:getShape():getPoints()))
--
--        love.graphics.setColor(200, 170, 100)
--        love.graphics.circle("line", self.x, self.y, 1, 6)
--        love.graphics.circle("line", self.x, self.y, 3, 24)

        -- Create ray cast
--        local Ray1 = {
--            point1 = {},
--            point2 = {},
--        }
--        Ray1.point1.x, Ray1.point1.y = 0,    -200
--        Ray1.point2.x, Ray1.point2.y = 1000,  1000
--        Ray1.scale = 1
--
--        local r1nx, r1ny, r1f = self.fixture:getShape():rayCast(
--            Ray1.point1.x, Ray1.point1.y,
--            Ray1.point2.x, Ray1.point2.y,
--            Ray1.scale,
--            self.x, self.y, 1.5)
--
--        if r1nx then
--            -- Calculating the world position where the ray hit.
--            local r1HitX = Ray1.point1.x + (Ray1.point2.x - Ray1.point1.x) * r1f
--            local r1HitY = Ray1.point1.y + (Ray1.point2.y - Ray1.point1.y) * r1f
--
--            -- Drawing the ray from the starting point to the position on the shape.
--            love.graphics.setColor(255, 0, 255)
--            love.graphics.line(Ray1.point1.x, Ray1.point1.y, r1HitX, r1HitY)
--
--            -- We also get the surface normal of the edge the ray hit. Here drawn in green
--            love.graphics.setColor(0, 255, 0)
--            love.graphics.line(r1HitX, r1HitY, r1HitX + r1nx * 25, r1HitY + r1ny * 25)
--
--            colorDefaultApply()
--        end
    end

    function obj:update(dt, world)
        -- TODO: use this for draw
        local dist_from_gun = distance(
            self.x, self.y,
            self.weapon.ship:getBody():getX(), self.weapon.ship:getBody():getY()
        )

        self.x = self:getBody():getX()
        self.y = self:getBody():getY()

        -- Update entity animation
        local now = love.timer.getTime()

        if (self.quad == nil) or (now - self.quad_time >= self.interval) then

            if self.quad ~= nil then
                self.frames:push(self.quad)
            end

            self.quad_time = now
            self.quad = self.frames:pop()
        end
    end

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
