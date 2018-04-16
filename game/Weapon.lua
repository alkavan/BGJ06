Projectile = require "Projectile"

---
-- Helper to draw aiming details on screen (debug)
-- @param x
-- @param y
-- @param length
-- @param angle
-- @param spread_deg
--
function drawAimHelper(x, y, length, angle, spread_deg)
    -- Circle
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("line", x, y, length, 16)

    -- Aim spread lines
    love.graphics.setColor(255, 0, 0)
    local length = length*1.25

    local end_x = x + length * math.sin(angle+math.rad(spread_deg));
    local end_y = y + length * -math.cos(angle+math.rad(spread_deg));
    love.graphics.line(x, y, end_x, end_y)

    end_x = x + length * math.sin(angle-math.rad(spread_deg));
    end_y = y + length * -math.cos(angle-math.rad(spread_deg));
    love.graphics.line(x, y, end_x, end_y)
end

-- Weapon
local Weapon = {}
Weapon.__index = Weapon;

---
-- Create new ship weapon module
-- @param length
-- @param ship
--
function Weapon:create(length, ship)
    local obj = Entity:create({
        name          = "Weapon",
        ship          = ship,
        angle         = ship:getBody():getAngle(),
        deg           = math.deg(ship:getBody():getAngle()),
        length        = length,
        reload_time   = 0.333,
        reload_total  = 0.0,
        loaded        = true,
        power         = 200,
        power_max     = 250,
        audio2        = nil
    })

    obj.shots = Queue:create()

    obj.audio2 = love.audio.newSource("asset/effects/laser2.mp3", "static")
    obj.audio2:setPitch(2.0)

    local sx, sy = ship:getPosition()
    obj:setPosition(sx, sy)

    setmetatable(obj, self)

    ---
    -- Update
    -- @param dt
    -- @param world
    --
    function obj:update(dt, world)
        local sx, sy = self.ship:getPosition()
        self:setPosition(sx, sy)

        self.angle = self.ship:getBody():getAngle()
        self.deg   = math.deg(self.ship:getBody():getAngle())

        -- Shots
        for i,shot in pairs(self.shots) do
            if type(i) == "number" then
                shot:update(dt, world)
            end
        end
    end

    ---
    -- Draw
    --
    function obj:draw()
        local sx, sy = self.ship:getPosition();

        drawAimHelper(sx, sy, self.length, self.angle, 8)
        colorDefaultApply()

        -- Shots
        for i,shot in pairs(self.shots) do
            if type(i) == "number" then
                shot:draw()
            end
        end
    end

    ---
    -- Aim player weapon
    -- @param mx
    -- @param my
    --
    function obj:aim(mx, my)
        self.x2 = mx
        self.y2 = my
    end

    ---
    -- Power up weapon
    --
    function obj:powerDown()
        if self.power > 0 then
            self.power = self.power - 50
        end
    end

    ---
    -- Power down weapon
    --
    function obj:powerUp()
        if self.power < self.power_max then
            self.power = self.power + 50
        end
    end

    ---
    -- Fire weapon
    --
    function obj:fire()
        if self.loaded then
            self.audio2:stop()
            self.shots:push(Projectile:create(self))
            self.audio2:play()
        end

        self.loaded = false
    end

    ---
    -- Reload weapon
    -- @param dt
    --
    function obj:reload(dt)
        if self.loaded == false then
           self.reload_total = self.reload_total + dt

           if self.reload_total >= self.reload_time then
               self.reload_total = 0.0
               self.loaded = true
           end
        end
    end

    ---
    -- Destroy all shots fired by this weapon
    --
    function obj:clearShots()
        for i,shot in pairs(self.shots) do
            if type(i) == "number" then
                shot:destroy()
            end
        end

        self.shots:clear()
    end

    return obj
end

return Weapon
