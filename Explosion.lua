local Explosion = {}
Explosion.__index = Explosion;

---
-- Create new explosion object
-- @param projectile
--
function Explosion:create(projectile)
    local obj = Entity:create({
        name       = "Explosion",
        projectile = projectile,
        image      = nil,
        damage     = 1000
    })


    local px, py = projectile:getPosition()
    obj:setPosition(px, py)

    -- Load ship image
    obj.image = love.graphics.newImage("asset/explosion1.png")

    -- Create animation properties
    obj.sprite = newAnimation(obj.image, 37, 37, 1.5)

    setmetatable(obj, self)

    ---
    -- Update
    -- @param dt
    --
    function obj:update(dt)
        self.sprite:update(dt)
    end

    ---
    -- Draw
    --
    function obj:draw()
        colorDefaultApply()
        local ex, ey = self:getPosition()
        self.sprite:draw(ex, ey, self.projectile:getBody():getAngle())
    end

    ---
    -- Destroy
    --
    function obj:destroy()
        self.image:release()
    end

    return obj
end

return Explosion
