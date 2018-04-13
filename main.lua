-- Include game helpers
require "common"
require "collusion"

-- Load game common modules
Queue  = require "Queue"
Object = require "Object"
Entity = require "Entity"

-- Gui
GuiFrame = require "GuiFrame"
MainMenu = require "MainMenu"

-- Game specific section
Stats      = require "Stats"
Planet     = require "Planet"
Player     = require "Player"
-- Weapon     = require "Weapon"
Projectile = require "Projectile"

-- Hump modules
Camera = require "hump.camera"

-- World constants { GM = gravity, GM = game multiplier }
GY = 0
GX = 0
GM = 64

-- Create game object
Game = {}

-- Game properties
Game.mouse_x    = 0
Game.mouse_y    = 0
Game.to_destory = Queue:create()
Game.planets    = Queue:create()
Game.player     = nil
Game.mmenu      = nil
Game.cam        = nil

-- Game Init
--
function love.load()

    -- Set interface font
    local main_font = love.graphics.newFont("Envy.ttf", 12)
    love.graphics.setFont(main_font)
    colorDefaultApply()
    
    -- Set physics
    love.physics.setMeter(GM)

    -- Main menu
    Game.mmenu = MainMenu:create(300,300,300,200,3)

    -- Create game world
    Game.world = love.physics.newWorld(GX, GY, true)
    Game.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- Create player entity
    Game.player = Player:create(Game.world)
    Game.cam = Camera(Game.player.x, Game.player.y)

    -- Create planet
    Game.planets:push(Planet:create(Game.world, colorRed(),    { x = 0,    y = -400 }, Planet.TYPE_RED))
    Game.planets:push(Planet:create(Game.world, colorRed(),    { x = 0,    y = 400  }, Planet.TYPE_RED))
    Game.planets:push(Planet:create(Game.world, colorRed(),    { x = 400,  y = 0    }, Planet.TYPE_RED))
    Game.planets:push(Planet:create(Game.world, colorRed(),    { x = -400, y = 0    }, Planet.TYPE_RED))
    
    Game.planets:push(Planet:create(Game.world, colorOrange(),    { x = -400, y = 200  }, Planet.TYPE_ORANGE))
    Game.planets:push(Planet:create(Game.world, colorOrange(),    { x = -400, y = -200 }, Planet.TYPE_ORANGE))
    Game.planets:push(Planet:create(Game.world, colorOrange(),    { x = 400,  y = 200  }, Planet.TYPE_ORANGE))
    Game.planets:push(Planet:create(Game.world, colorOrange(),    { x = 400,  y = -200 }, Planet.TYPE_ORANGE))

    Game.planets:push(Planet:create(Game.world, colorYellow(),    { x = 200,  y = -400 }, Planet.TYPE_YELLOW))
    Game.planets:push(Planet:create(Game.world, colorYellow(),    { x = -200, y = -400 }, Planet.TYPE_YELLOW))

    Game.planets:push(Planet:create(Game.world, colorGreen(),    { x = 200,  y = 400 }, Planet.TYPE_GREEN))
    Game.planets:push(Planet:create(Game.world, colorGreen(),    { x = -200, y = 400 }, Planet.TYPE_GREEN))

    Game.planets:push(Planet:create(Game.world, colorBlue(),    { x = 400,  y = -400 }, Planet.TYPE_BLUE))
    Game.planets:push(Planet:create(Game.world, colorBlue(),    { x = 400, y = 400 }, Planet.TYPE_BLUE))

    Game.planets:push(Planet:create(Game.world, colorIndigo(),    { x = -400,  y = 400 }, Planet.TYPE_INDIGO))

    Game.planets:push(Planet:create(Game.world, colorViolet(),    { x = -400, y = -400 }, Planet.TYPE_VIOLET))
       
    love.keyboard.setKeyRepeat(true)
end

-- Main draw function
--
function love.draw()

    -- Attach camera
    Game.cam:attach()

    -- Apply default draw color
    colorDefaultApply()

    -- Draw level
    for i,planet in pairs(Game.planets) do
        if type(i) == "number" then
            planet:draw()
        end
    end

    -- Draw player
    Game.player:draw()
    
    local x,y = Game.player:getBody():getWorldCenter()
    local mx, my = Game.cam:mousepos()
    love.graphics.line(x, y, mx, my)

    -- Detach camera
    Game.cam:detach()

    -- Print mouse info line
    love.graphics.print("MOUSE -> ("..round(mx, 0)..","..round(my, 0)..") | GAME -> ("..Game.mouse_x..","..Game.mouse_y..")", 10, 10)


    cx, cy = Game.cam:worldCoords(love.mouse.getPosition())
    love.graphics.print("CAMERA -> W("..round(cx, 0)..","..round(cy, 0)..") | ("..Game.mouse_x..","..Game.mouse_y..")", 10, 22)

    -- Draw stats
    Stats:draw(Game.player)

    -- Draw game menu
    Game.mmenu:draw()
end

-- Game update
function love.update(dt)

    -- Update planets
    for i,planet in pairs(Game.planets) do
        if type(i) == "number" then
            planet:update(dt)
        end
    end

    Game.world:update(dt)
    Game.player:update(dt, Game.world, Game.cam)

    -- Update camera
    local dx,dy = Game.player.x - Game.cam.x, Game.player.y - Game.cam.y
    Game.cam:move(dx/2, dy/2)
end

-- Mouse press event
function love.mousepressed(x, y, button)
    -- Left mouse button press
    if button == 'l' then
        -- Fire
    elseif button == 'r' then
        -- Other action
    end

    Game.mouse_x = x
    Game.mouse_y = y
end

-- Keyboard press event
-- @param unicode integer representation
function love.keypressed(key, unicode)

    if key == 'w' then
        local mx, my = Game.cam:mousepos()
        Game.player:moveToMouse(mx, my)
    elseif key == 'escape' then
        print(key)
        Game.mmenu:toggle()
    elseif key == 'up' then
        Game.mmenu:moveUp()
    elseif key == 'down' then
        Game.mmenu:moveDown()
    elseif key == 'return' then
        Game.mmenu:select()
    end
end

-- Quit
function love.quit()
    print("Thanks for playing! Come back soon!")
end
