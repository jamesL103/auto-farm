local auto_farm = require('auto_farm').auto_farm

local width, height
if arg[1] == nil then
    width = 9
    height = 9
else 
    width = tonumber(arg[1])
    height = tonumber(arg[2])
    assert(width ~= nil and height ~= nil)
end

local MIN_FUEL = 400 -- TODO: create function relative to width and height

-- main farming loop
while true do
    auto_farm(width, height)
    turtle.turnLeft()

    -- deposit all items into storage
    for slot = 1, 16 do
        turtle.select(slot)
        if (turtle.getItemCount(slot) > 0) then
            turtle.drop()
        end
    end

    -- check for fuel count
    if turtle.getFuelLevel() < MIN_FUEL then
        
    end
end