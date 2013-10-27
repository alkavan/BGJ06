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
        density       = 10*GM,
        integrity     = 5000,
        integrity_max = 8000,
        integrity_cur = 5000,
        score         = 0
    })

    setmetatable(obj, self)

    -- Create body, shape and combine into fixture
    local body    = love.physics.newBody(world, x, y, "dynamic")
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

    --
    -- Methods
    --    

    -- On draw
    function obj:draw()
        colorDefaultApply()

        love.graphics.drawq(self.image, self.quad, self.x, self.y, self:getBody():getAngle(), 1, 1, 0, 0)

        colorDefaultApply()
        love.graphics.polygon("line", self:getBody():getWorldPoints(self:getShape():getPoints()))
    end

    -- On update
    function obj:update(dt, world, cam)
        -- Update entity animation
        local now = love.timer.getTime()

        if (self.quad == nil) or (now - self.quad_time >= self.interval) then

            if self.quad ~= nil then
                self.frames:push(self.quad)    
            end

            self.quad_time = now
            self.quad = self.frames:pop()
        end

        self.x, self.y = self:getBody():getWorldCenter()

        -- Get mouse position
        local mx, my = cam:mousepos()
        local x, y  = self:getBody():getWorldCenter()

        local deltaX = mx - x
        local deltaY = my - y
        -- calculate the angle

        d_radians = math.atan2(dt*deltaX/GM, dt*deltaY/GM)
        d_degrees = (d_radians + math.pi) * 360.0 / (2.0 * math.pi);
        d_degrees = 360 - d_degrees

        -- print("A: "..round(d_degrees, 1))
        self:getBody():setAngle(math.rad(d_degrees))
    end

    function obj:moveToMouse(mx, my)
        local tx, ty = self:getBody():getWorldCenter()
        local angle = self:getBody():getAngle()

        local maxTorque = 1000*GM
        local inertia = self:getBody():getInertia()
        local w = self:getBody():getAngularVelocity()
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
        self:getBody():applyTorque(torque)

        local vx = mx-tx
        local vy = my-ty

        local d12 = math.sqrt(vx^2 + vy^2)
        local f1x = GM*vx/d12
        local f1y = GM*vy/d12
        -- print("f1x, f1y: "..f1x..","..f1y)

        self:getBody():applyForce(10000*f1x, 10000*f1y, mx, my)
    end

    return obj
end

return Player
