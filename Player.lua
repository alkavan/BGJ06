Ship = require "Ship"

-- Player object
local Player = {}
Player.__index = Player

function Player:create(world)

    local x = 500
    local y = 300

    local obj = Entity:create({
        name          = "Player",
        x             = x,
        y             = y,
        score         = 0,
        ship          = nil
    })

    setmetatable(obj, self)

    -- Create ship entity
    obj.ship = Ship:create(world, obj)

    --
    -- Methods
    --    

    -- On draw
    function obj:draw()
        colorDefaultApply()
        self.ship:draw()
        love.graphics.polygon("line", self.ship:getBody():getWorldPoints(self.ship:getShape():getPoints()))
    end

    -- On update
    function obj:update(dt, world, cam)
        self.x, self.y = self.ship:getBody():getWorldCenter()

        -- Get mouse position
        local mx, my = cam:mousepos()
        local x, y  = self.ship:getBody():getWorldCenter()

        local deltaX = mx - x
        local deltaY = my - y
        -- calculate the angle

        local d_radians = math.atan2(dt*deltaX/GM, dt*deltaY/GM)
        local d_degrees = (d_radians + math.pi) * 360.0 / (2.0 * math.pi);

        -- print("A: "..round(d_degrees, 1))
        self.ship:getBody():setAngle(math.rad(360 - d_degrees))
        self.ship:update(dt, world)
    end

    function obj:moveToMouse(mx, my)
        local tx, ty = self.ship:getBody():getWorldCenter()
        local angle = self.ship:getBody():getAngle()

        local maxTorque = 1000*GM
        local inertia = self.ship:getBody():getInertia()
        local w = self.ship:getBody():getAngularVelocity()
        local targetAngle = math.atan2(ty-y,tx-x)

        -- distance I have to cover
        local differenceAngle = math.normalizeAngle(targetAngle - angle)

        -- distance it will take me to stop
        local brakingAngle = math.normalizeAngle(math.sign(w)*2.0*w*w*inertia/maxTorque)

        local torque = maxTorque

        -- two of these 3 conditions must be true
        local a,b,c = differenceAngle > math.pi, brakingAngle > differenceAngle, w > 0
        
        if( (a and b) or (a and c) or (b and c) ) then
            torque = -torque
        end
        -- print("target/diff: "..targetAngle.."/"..differenceAngle)
        -- print("torque: "..torque)
        self.ship:getBody():applyTorque(torque)

        local vx = mx-tx
        local vy = my-ty

        local d12 = math.sqrt(vx^2 + vy^2)
        local f1x = GM*vx/d12
        local f1y = GM*vy/d12
        -- print("f1x, f1y: "..f1x..","..f1y)

        self.ship:getBody():applyForce(10000*f1x, 10000*f1y, mx, my)
    end

    return obj
end

return Player
