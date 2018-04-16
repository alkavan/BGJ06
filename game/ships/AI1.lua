AiShip = require "game/Ship"

-- Ship MODEL: AI-1
local AI1 = {}
AI1.__index = AI1

function AI1:create(world, player)
    local ship = AiShip:create(world, player)

    -- Load ship image
    ship.image = love.graphics.newImage("asset/ship2.png")

    -- Create animation properties
    ship.sprite = newAnimation(ship.image, 32, 32, 3.0)

    -- Ship weapon
    ship.weapon = Weapon:create(16, ship)

    return ship
end

return AI1
