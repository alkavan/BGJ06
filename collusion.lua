---
-- On contact
-- @param a
-- @param b
-- @param coll
--
function beginContact(a, b, coll)
    local entity_a = a:getUserData()
    local entity_b = b:getUserData()

    if entity_a.name == "Projectile" then
        entity_a.collided = true
    end

    if entity_a.name == "Player" and entity_b.name == "Player" then
        print("!!!!!!!!!!!!!!!!!!!!!!!!!")
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