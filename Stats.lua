-- Game information and data
local Stats = {}
Stats.__index = Stats

Stats.energy_red    = 0
Stats.energy_orange = 0
Stats.energy_yellow = 0
Stats.energy_green  = 0
Stats.energy_blue   = 0
Stats.energy_indigo = 0
Stats.energy_violet = 0

function Stats:draw(player)
    love.graphics.print("HP: "..player.integrity.."/"..player.integrity_cur, 10, 50)
    love.graphics.print("SCORE: "..player.score, 10, 70)

    love.graphics.print("RED:    "..self.energy_red, 10, 100)
    love.graphics.print("ORANGE: "..self.energy_orange, 10, 120)
    love.graphics.print("YELLOW: "..self.energy_yellow, 10, 140)
    love.graphics.print("GREEN:  "..self.energy_green, 10, 160)
    love.graphics.print("BLUE:   "..self.energy_blue, 10, 180)
    love.graphics.print("INDIGO: "..self.energy_indigo, 10, 200)
    love.graphics.print("VIOLET: "..self.energy_violet, 10, 220)
end

function Stats:reset()
	self.energy_red    = 0
	self.energy_orange = 0
	self.energy_yellow = 0
	self.energy_green  = 0
	self.energy_blue   = 0
	self.energy_indigo = 0
	self.energy_violet = 0

	-- Reset player
	Game.player.score = 0
	Game.player:getBody():setPosition(0,0)
	Game.player:getBody():setLinearVelocity(0, 0)
end

return Stats
