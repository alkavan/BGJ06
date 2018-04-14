Ship = require "Ship"

-- Player object
local Player = {}
Player.__index = Player

---
-- Create new player object
-- @param world
-- @param position
--
function Player:create(world, position)

    if position == nil then
        position = {x = 0, y = 0 }
    end

    local obj = Entity:create({
        name          = "Player",
        position      = position,
        score         = 0,
        ship          = nil
    })

    -- Create ship entity
    obj.ship = Ship:create(world, obj)

    setmetatable(obj, self)

    ---
    -- Draw
    --
    function obj:draw()
        self.ship:draw()

        local x, y = self:getPosition()
        love.graphics.setColor(0, 255, 0)
        love.graphics.circle("line", x, y, 16, 16)
        colorDefaultApply()
    end

    ---
    -- Update
    -- @param dt
    -- @param world
    -- @param cam
    --
    function obj:update(dt, world, cam)

        local sx, sy = self.ship:getBody():getWorldCenter()
        self:setPosition(sx, sy)

        -- Get mouse position
        local mx, my = cam:mousepos()

        local deltaX = mx - sx
        local deltaY = my - sy

        -- Calculate the angle
        local d_radians = math.atan2(dt*deltaX, dt*deltaY)
        local d_degrees = (d_radians + math.pi) * 360.0 / (2.0 * math.pi);

        -- print("A: "..round(d_degrees, 1))
        self.ship:getBody():setAngle(math.rad(360 - d_degrees))
        self.ship:update(dt, world)
    end

    ---
    -- Move player ship to mouse position
    -- @param mx
    -- @param my
    --
    function obj:moveToMouse(mx, my)
        local px, py = self:getPosition()
        local tx, ty = self.ship:getBody():getWorldCenter()
        local angle  = self.ship:getBody():getAngle()

        local inertia = self.ship:getBody():getInertia()
        local w = self.ship:getBody():getAngularVelocity()
        local targetAngle = math.atan2(ty-py,tx-px)

        -- distance I have to cover
        local differenceAngle = math.normalizeAngle(targetAngle - angle)

        -- distance it will take me to stop
        local brakingAngle = math.normalizeAngle(math.sign(w)*2.0*w*w*inertia/self.ship.max_torque)

        local torque = self.ship.max_torque

        -- two of these 3 conditions must be true
        local a,b,c = differenceAngle > math.pi, brakingAngle > differenceAngle, w > 0
        
        if( (a and b) or (a and c) or (b and c) ) then
            torque = -torque
        end

        self.ship:getBody():applyTorque(torque)

        local vx = mx-tx
        local vy = my-ty

        local d12 = math.sqrt(vx^2 + vy^2)
        local f1x = self.ship.max_torque*vx/d12
        local f1y = self.ship.max_torque*vy/d12

        self.ship:getBody():applyForce(f1x, f1y, mx, my)
    end

    return obj
end

return Player
