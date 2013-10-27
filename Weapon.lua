-- Weapon
local Weapon = {}
Weapon.__index = Weapon;

function Weapon:create(length, world, player)

    local obj = Entity:create({
        name          = "Weapon",
        parent        = player,
        x             = player.x,
        y             = player.y,
        deg           = 90,
        length        = length,
        reload_time   = 0.3,
        reload_total  = 0.0,
        loaded        = false,
        power         = 2000,
        power_max     = 2000
    })

    obj.x2 = obj.x+obj.length
    obj.y2 = obj.y

    obj.shots = Queue:create()

    setmetatable(obj, self)

    function obj:draw()

        love.graphics.setColor(200, 120, 255)
        love.graphics.line({
            self.x, self.y,
            self.x2, self.y2
        })

        love.graphics.setColor(0, 255, 0)
        love.graphics.circle("line", self.x, self.y, self.length, 100 )

        colorDefaultApply()
        -- Shots
        for i,shot in pairs(self.shots) do
            if type(i) == "number" then
                shot:draw()
            end
        end
    end

    function obj:update(dt, world)
        self.x = self.parent.x
        self.y = self.parent.y

        -- Shots
        for i,shot in pairs(self.shots) do
            if type(i) == "number" then
                shot:update(dt, world)
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

    function obj:fire(dt, world)
        if self.loaded then
            local shot = Projectile:create(dt, world, self)
            self.shots:push(shot)
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

