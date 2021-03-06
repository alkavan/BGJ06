-- Math related
function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function range(i, to, inc)
    if i == nil then return end -- range(--[[ no args ]]) -> return "nothing" to fail the loop in the caller

    if not to then
        to = i
        i  = to == 0 and 0 or (to > 0 and 1 or -1)
    end

    -- we don't have to do the to == 0 check
    -- 0 -> 0 with any inc would never iterate
    inc = inc or (i < to and 1 or -1)

    -- step back (once) before we start
    i = i - inc

    return function () if i == to then return nil end i = i + inc return i, i end
end

-- Convert to radians degrees
-- Check if needed
toDegrees = function(radians) return radians * 180 / math.pi end

-- Distance between two points
function distance(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt( dx * dx + dy * dy )
end

-- Deep object copy function
function deepcopy (t)
    if type(t) ~= 'table' then return t end
    local mt = getmetatable(t)
    local res = {}
    for k,v in pairs(t) do
        if type(v) == 'table' then
            v = deepcopy(v)
        end
        res[k] = v
    end
    setmetatable(res, mt)
    return res
end

function math.normalizeAngle(angle)
    while (angle >= 360.0) do 
            angle = angle - 360.0;
    end
    
    while (angle < 0.0) do
            angle = angle + 360.0;
    end

    return angle;
end

function math.sign(x)
   if x<0 then
     return -1
   elseif x>0 then
     return 1
   else
     return 0
   end
end

function colorDefaultApply(alpha)
    love.graphics.setColor(255, 255, 255, alpha)
end

function colorDefault(alpha)
    return {r=255, g=255, b=255, a=alpha}
end

function colorRed(alpha)
    return {r=255, g=0, b=102, a=alpha}
end

function colorOrange(alpha)
    return {r=242, g=0, b=162, a=alpha}
end

function colorYellow(alpha)
    return {r=255, g=255, b=102, a=alpha}
end

function colorGreen(alpha)
    return {r=62, g=242, b=0, a=alpha}
end

function colorBlue(alpha)
    return {r=0, g=0, b=255, a=alpha}
end

function colorIndigo(alpha)
    return {r=111, g=0, b=255, a=alpha}
end

function colorViolet(alpha)
    return {r=143, g=0, b=255, a=alpha}
end

---
-- New sprite animation
-- @param image
-- @param width
-- @param height
-- @param duration
--
function newAnimation(image, width, height, duration)

    local animation = {
        current_index = 1,
        duration      = duration or 1,
        current_time  = 0
    }

    local sprite = love.graphics.newSpriteBatch(image, 1)

    local image_w = image:getWidth()
    local image_h = image:getHeight()

    local oriantation = image_h / image_w
    local index = {}

    if oriantation < 1 then
        for x = 0, image_w - width, width do
            for y = 0, image_h - height, height do
                local id = sprite:add(love.graphics.newQuad(x, y, width, height, image_w, image_h))
                index[id-1] = id
            end
        end
    else
        for y = 0, image_h - height, height do
            for x = 0, image_w - width, width do
                local id = sprite:add(love.graphics.newQuad(x, y, width, height, image_w, image_h))
                index[id-1] = id
            end
        end
    end

    animation.sprite = sprite

    function animation:update(dt)

        local duration = dt * self.duration

        self.current_time = self.current_time + dt
        if self.current_time >= duration then
            self.current_time = self.current_time - duration

            if(self.current_index == self.sprite:getBufferSize()) then
                self.current_index = 1
                return
            end

            self.current_index = self.current_index + 1
        end
    end

    function animation:getSize()
        if oriantation < 1
        then return width
        else return height end
    end

    function animation:draw(x, y, angel)
        local size = height
        if oriantation < 1
        then size = width end

        self.sprite:setDrawRange(self.current_index, 1)
        love.graphics.draw(self.sprite, x, y, angel, 1, 1, size/2, size/2)
    end

    return animation
end
