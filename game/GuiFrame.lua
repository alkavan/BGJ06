
-- GuiFrame object
local GuiFrame = {}
GuiFrame.__index = GuiFrame

function GuiFrame:create(x, y, w, h, border_width)

	local border_width = border_width or 1

	local obj = Object:create({
    	x1 = x, y1 = y,
	    x2 = x+w, y2 = y+h,
	    w = w, h = h,
    	border_width = border_width,
	})

    setmetatable(obj, self)

    --
    -- Methods
    --

    -- On draw
    function obj:draw()
    	love.graphics.setLineWidth(self.border_width)
    	love.graphics.line(self.x1, self.y1, self.x2, self.y1)
    	love.graphics.line(self.x2, self.y1, self.x2, self.y2)
    	love.graphics.line(self.x2, self.y2, self.x1, self.y2)
    	love.graphics.line(self.x1, self.y2, self.x1, self.y1)
    	love.graphics.setLineWidth(1)
    end

    -- On update
    function obj:update(dt)

    end

    return obj
end

return GuiFrame