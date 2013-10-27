-- On contact
function beginContact(a, b, coll)
    local fx,fy = coll:getNormal()

    local da = a:getUserData()
    local db = b:getUserData()
    if da.name == "Player" and db.name == "Planet" then

        da.score = da.score + 100

        if db.energy_type == Planet.TYPE_RED then
            Stats.energy_red = Stats.energy_red + 100
        elseif db.energy_type == Planet.TYPE_ORANGE then
            Stats.energy_orange = Stats.energy_orange + 100
        elseif db.energy_type == Planet.TYPE_YELLOW then
            Stats.energy_yellow = Stats.energy_yellow + 100
        elseif db.energy_type == Planet.TYPE_GREEN then
            Stats.energy_green = Stats.energy_green + 100
        elseif db.energy_type == Planet.TYPE_BLUE then
            Stats.energy_blue = Stats.energy_blue + 100
        elseif db.energy_type == Planet.TYPE_INDIGO then
            Stats.energy_indigo = Stats.energy_indigo + 100
        elseif db.energy_type == Planet.TYPE_VIOLET then
            Stats.energy_violet = Stats.energy_violet + 100
        end
    end

    print(da.name.." colliding with "..db.name.." with a vector normal of: "..fx..", "..fy)
end

-- Leaving object
function endContact(a, b, coll)
    local da = a:getUserData()
    local db = b:getUserData()
    print(da.name.." uncolliding with "..db.name)
end

-- Wait before contact
function preSolve(a, b, coll)
--    print(a:getUserData().." touching "..b:getUserData())
end

-- In contact
function postSolve(a, b, coll)
--    print(a:getUserData().." in contact with "..b:getUserData())
end