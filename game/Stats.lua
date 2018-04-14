-- Game information and data
local Stats = {}
Stats.__index = Stats

function Stats:draw(players)
    for k, player in pairs(players) do
        local offset = 60
        local line_space = 15

        local fields = {
            PLAYER = player.name,
            HP     = player.ship.integrity.."/"..player.ship.integrity_cur,
            SCORE  = player.score
        }

        local l = 1
        local x = 10
        for field, value in pairs(fields) do
            love.graphics.print(field..": "..value, x, (offset*k)+(k+1)+line_space*(l))
            l = l+1
        end
    end
end

function Stats:reset()
    -- Reset player
    Game.player.score    = 0
    Game.ai_player.score = 0
end

return Stats
