---
-- On contact
-- @param a
-- @param b
-- @param coll
--
function beginContact(a, b, coll)
    local entity_a = a:getUserData()
    local entity_b = b:getUserData()

    if entity_a.name == "Player" and entity_b.name == "Planet" then
        entity_a.score = entity_a.score + 100

        if entity_b.energy_type == Planet.TYPE_RED then
            Stats.energy_red = Stats.energy_red + 100
        elseif entity_b.energy_type == Planet.TYPE_ORANGE then
            Stats.energy_orange = Stats.energy_orange + 100
        elseif entity_b.energy_type == Planet.TYPE_YELLOW then
            Stats.energy_yellow = Stats.energy_yellow + 100
        elseif entity_b.energy_type == Planet.TYPE_GREEN then
            Stats.energy_green = Stats.energy_green + 100
        elseif entity_b.energy_type == Planet.TYPE_BLUE then
            Stats.energy_blue = Stats.energy_blue + 100
        elseif entity_b.energy_type == Planet.TYPE_INDIGO then
            Stats.energy_indigo = Stats.energy_indigo + 100
        elseif entity_b.energy_type == Planet.TYPE_VIOLET then
            Stats.energy_violet = Stats.energy_violet + 100
        end
    end

    if entity_a.name == "Projectile" and entity_b.name ~= "Ship" then
        entity_a.collided = true
    end

    local fx, fy = coll:getNormal()
    print(entity_a.name.." colliding with ".. entity_b.name.." with a vector normal of: "..fx..", "..fy)
end

---
-- Leaving object
-- @param a
-- @param b
-- @param coll
--
function endContact(a, b, coll)
    local da = a:getUserData()
    local db = b:getUserData()
    print(da.name.." uncolliding with "..db.name)
end

---
-- Wait before contact
-- @param a
-- @param b
-- @param coll
--
function preSolve(a, b, coll)
--    print(a:getUserData().." touching "..b:getUserData())
end

---
-- In contact
-- @param a
-- @param b
-- @param coll
--
function postSolve(a, b, coll)
--    print(a:getUserData().." in contact with "..b:getUserData())
end