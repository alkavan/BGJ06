-- Entity
-- a general game object
local Entity = {}
Entity.__index = Entity

function Entity:create(obj)
	local obj = obj or Object:create({
	    name = "Entity",
	    position = {x = 0, y = 0},
	    fixture = nil,
	})

	setmetatable(obj, self)

	-- Get fixure body
	function obj:getBody()
	    return self.fixture:getBody()
	end

	-- Get fixure shape
	function obj:getShape()
	    return self.fixture:getShape()
	end

	return obj
end

 	

return Entity
