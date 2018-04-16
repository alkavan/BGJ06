Ship = require "game/Ship"

-- Ship MODEL: WD-1
local WD1 = {}
WD1.__index = WD1

function WD1:create(world, player)
    local ship = Ship:create(world, player)

    -- Load ship image
    ship.image = love.graphics.newImage("asset/ship1.png")

    -- Create animation properties
    ship.sprite = newAnimation(ship.image, 32, 32, 3.0)

    -- Ship weapon
    ship.weapon = Weapon:create(16, ship)

    return ship
end

return WD1
