-- MainMenu object
local MenuMenu = {}
MenuMenu.__index = MenuMenu

MenuMenu.ITEM_NEW_GAME  = 0
MenuMenu.ITEM_HIGHSCORE = 1
MenuMenu.ITEM_OPTIONS   = 2
MenuMenu.ITEM_QUIT      = 3

function MenuMenu:create(x, y, w, h, border_width)

	local border_width = border_width or 1

	local obj = Object:create({
    	frame = GuiFrame:create(x, y, w, h, border_width),
		items = Queue:create(),
	})

    setmetatable(obj, self)

    obj.items:push("New Game")
    obj.items:push("Highscores")
    obj.items:push("Options")
    obj.items:push("Quit")
    
    obj.selected = 0
    obj.padding  = 10
    obj.closed   = false

    --
    -- Methods
    --

    -- On draw
    function obj:draw()

        if self.closed == true then
            return
        end

    	self.frame:draw()

    	for i,item in pairs(self.items) do
        	if type(i) == "number" then
            	love.graphics.print(item, self.frame.x1+self.padding, self.frame.y1+self.padding+(i*20))
            	if i == self.selected then
            		local line_y = self.frame.y1+self.padding+(20*i)+15
            		
            		love.graphics.line(
            			self.frame.x1+self.padding,
            			line_y,
            			self.frame.x2-self.padding,
            			line_y
            		)
            	end
        	end
    	end
    end

    -- On update
    function obj:update(dt)

    end

    -- Keyboard bind points
    function obj:moveUp()
        if self.closed == true then
            return
        end

    	if self.selected > 0 then
    		self.selected = self.selected - 1
    	end
    end

    function obj:moveDown()
        if self.closed == true then
            return
        end

    	if self.selected < obj.items:len()-1 then
    		self.selected = self.selected + 1
    	end
    end

    function obj:toggle()
        if self.closed == true then
            self.closed = false
        else
            self.closed = true
        end
    end

    function obj:select()
        if self.closed == true then
            return
        end

        if self.selected == self.ITEM_NEW_GAME then
            Stats:reset()
            self.closed = true
        elseif self.selected == self.ITEM_HIGHSCORE then
        elseif self.selected == self.ITEM_OPTIONS then
        elseif self.selected == self.ITEM_QUIT then
            self.closed = true
            love.quit()
        end
    end

    return obj
end

return MenuMenu
