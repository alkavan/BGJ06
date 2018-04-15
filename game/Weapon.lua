Projectile = require "game/Projectile"

-- Weapon
local Weapon = {}
Weapon.__index = Weapon;

function drawAimHelper(x, y, length, angle, spread_deg)
    love.graphics.setColor(255, 0, 0)

    local length = length*1.25

    local end_x = x + length * math.sin(angle+math.rad(spread_deg));
    local end_y = y + length * -math.cos(angle+math.rad(spread_deg));
    love.graphics.line(x, y, end_x, end_y)

    end_x = x + length * math.sin(angle-math.rad(spread_deg));
    end_y = y + length * -math.cos(angle-math.rad(spread_deg));
    love.graphics.line(x, y, end_x, end_y)
end

function Weapon:create(length, ship)
    local obj = Entity:create({
        name          = "Weapon",
        ship          = ship,
        angle         = ship:getBody():getAngle(),
        deg           = math.deg(ship:getBody():getAngle()),
        length        = length,
        reload_time   = 0.3,
        reload_total  = 0.0,
        loaded        = true,
        power         = 20,
        power_max     = 1000
    })

    obj.shots = Queue:create()

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
        love.graphics.setColor(0, 255, 0)
        local sx, sy = self.ship:getPosition();

        love.graphics.circle("line", sx, sy, self.length, 16)

        drawAimHelper(sx, sy, self.length, self.angle, 8)

        colorDefaultApply()

        -- Shots
        for i,shot in pairs(self.shots) do
            if type(i) == "number" then
                shot:draw()
            end
        end
    end

    function obj:aim(mx, my)
        self.x2 = mx
        self.y2 = my
    end

    function obj:powerDown()
        if self.power > 0 then
            self.power = self.power - 50
        end
    end

    function obj:powerUp()
        if self.power < self.power_max then
            self.power = self.power + 50
        end
    end

    function obj:fire()
        if self.loaded then
            self.shots:push(Projectile:create(self))
        end

        self.loaded = false
    end

    function obj:reload(dt)
        if self.loaded == false then
           self.reload_total = self.reload_total + dt

           if self.reload_total >= self.reload_time then
               self.reload_total = 0.0
               self.loaded = true
           end
        end
    end

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
