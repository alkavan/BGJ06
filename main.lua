package.path = package.path .. ";game/?.lua"

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
Stats    = require "Stats"
Planet   = require "Planet"
Player   = require "Player"
AiPlayer = require "AiPlayer"

-- Hump modules
Camera = require "hump.camera"

-- World constants { GV = vertical gravity, GX = horisontal gravity }
GY = 0.0
GX = 0.0

-- Create game object
Game = {}

-- Game properties
Game.mx = 0
Game.my = 0
Game.to_destory = Queue:create()
Game.planets    = Queue:create()
Game.player     = nil
Game.ai_player  = nil
Game.mmenu      = nil
Game.cam        = nil
Game.music      = nil

-- Level object that contains groups of objects in level
Game.level = {
    boundary = nil
}

---
-- Create planets in level
--
function Game:createPlanets()
    -- Create planets
    Game.planets:push(Planet:create(Game.world, colorRed(),    { x = 0,    y = -400 }, Planet.TYPE_RED))
    Game.planets:push(Planet:create(Game.world, colorRed(),    { x = 0,    y = 400  }, Planet.TYPE_RED))
    Game.planets:push(Planet:create(Game.world, colorRed(),    { x = 400,  y = 0    }, Planet.TYPE_RED))
    Game.planets:push(Planet:create(Game.world, colorRed(),    { x = -400, y = 0    }, Planet.TYPE_RED))

    Game.planets:push(Planet:create(Game.world, colorOrange(),    { x = -400, y =  200  }, Planet.TYPE_ORANGE))
    Game.planets:push(Planet:create(Game.world, colorOrange(),    { x = -400, y = -200 }, Planet.TYPE_ORANGE))
    Game.planets:push(Planet:create(Game.world, colorOrange(),    { x =  400, y =  200  }, Planet.TYPE_ORANGE))
    Game.planets:push(Planet:create(Game.world, colorOrange(),    { x =  400, y = -200 }, Planet.TYPE_ORANGE))

    Game.planets:push(Planet:create(Game.world, colorYellow(),    { x =  200, y = -400 }, Planet.TYPE_YELLOW))
    Game.planets:push(Planet:create(Game.world, colorYellow(),    { x = -200, y = -400 }, Planet.TYPE_YELLOW))

    Game.planets:push(Planet:create(Game.world, colorGreen(),    { x =  200, y = 400 }, Planet.TYPE_GREEN))
    Game.planets:push(Planet:create(Game.world, colorGreen(),    { x = -200, y = 400 }, Planet.TYPE_GREEN))

    Game.planets:push(Planet:create(Game.world, colorBlue(),    { x = 400, y = -400 }, Planet.TYPE_BLUE))
    Game.planets:push(Planet:create(Game.world, colorBlue(),    { x = 400, y =  400 }, Planet.TYPE_BLUE))

    Game.planets:push(Planet:create(Game.world, colorIndigo(),    { x = -400,  y = 400 }, Planet.TYPE_INDIGO))

    Game.planets:push(Planet:create(Game.world, colorViolet(),    { x = -400, y = -400 }, Planet.TYPE_VIOLET))
end

---
-- Game Init
-- Handles loading of all resources, setup world and objects
--
function love.load()
    -- Audio
    local music = love.audio.newSource("asset/audio/lazerhawk-lnterstellar-EWHaG_uCvEA.mp3", "static")
--    music:play() -- TODO: fix music
    Game.music = music

    -- Set interface font
    local main_font = love.graphics.newFont("asset/font/Envy.ttf", 12)
    love.graphics.setFont(main_font)
    colorDefaultApply()

    -- Main menu
    Game.mmenu = MainMenu:create(300,300,300,200,3)

    -- Create game world
    Game.world = love.physics.newWorld(GX, GY, false)
    Game.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- Create player entity
    local player = Player:create(Game.world, {x = 0, y = 0}, "WD1")
    local px, py = player:getPosition()
    Game.cam = Camera(px, py)
    Game.player = player

    local ai_layer = AiPlayer:create(Game.world, {x = px - 100, y = py - 100}, "AI1")
    Game.ai_player = ai_layer

    -- Create planets
    Game.createPlanets()

    love.keyboard.setKeyRepeat(true)

    love.filesystem.setIdentity("beware-space")
end

---
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

    -- Draw AI Player
    Game.ai_player:draw()

    -- Draw mouse vector
    local x,y = Game.player.ship:getBody():getWorldCenter()
    local mx, my = Game.cam:mousepos()
    love.graphics.line(x, y, mx, my)

    -- Detach camera
    Game.cam:detach()

    -- Print mouse info line
    love.graphics.print("MOUSE -> ("..round(mx, 0)..","..round(my, 0)..") | GAME -> ("..Game.mx..","..Game.my..")", 10, 10)

    -- Print comera info line
    local cx, cy = Game.cam:worldCoords(love.mouse.getPosition())
    love.graphics.print("CAMERA -> W("..round(cx, 0)..","..round(cy, 0)..") | ("..Game.mx..","..Game.my..")", 10, 22)

    -- Draw stats
    Stats:draw({Game.player, Game.ai_player})

    -- Draw game menu
    Game.mmenu:draw()
end

---
-- Game update
-- @param dt
--
function love.update(dt)
    -- Update planets
    for i,planet in pairs(Game.planets) do
        if type(i) == "number" then
            planet:update(dt)
        end
    end

    Game.world:update(dt)
    Game.player:update(dt, Game.world, Game.cam)
    Game.ai_player:update(dt, Game.world)

    -- Update camera
    local dx = Game.player.position.x - Game.cam.x
    local dy = Game.player.position.y - Game.cam.y

    Game.cam:move(dx/2, dy/2)

    if love.mouse.isDown(1) then
        Game.player.ship.weapon:aim(Game.mx, Game.my)
        Game.player.ship.weapon:fire()
    end

    -- Save screen shot
--    love.graphics.captureScreenshot(os.time().. '_' .. dt .. ".png")
end

---
-- Mouse press event
-- @param x
-- @param y
-- @param button
-- @param istouch
--
function love.mousepressed(x, y, button, istouch)
    Game.mx = x
    Game.my = y

    -- Left mouse button press
    if button == 1 then
        -- Fire
--        Game.player.ship.weapon:fire()
    elseif button == 2 then
        -- Other action
    end
end

---
-- Keyboard press event
-- @param key
-- @param unicode Integer representation
--
function love.keypressed(key, unicode)

    if key == 'w' then
        local mx, my = Game.cam:mousepos()
        Game.player:moveToMouse(mx, my)
    elseif key == 'escape' then
        Game.mmenu:toggle()
    elseif key == 'up' then
        Game.mmenu:moveUp()
    elseif key == 'down' then
        Game.mmenu:moveDown()
    elseif key == 'return' then
        Game.mmenu:select()
    end
end

---
-- Quit
--
function love.quit()
    print("Thanks for playing! Come back soon!")
end
