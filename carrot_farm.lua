local auto_farm = require('auto_farm').auto_farm
local WAIT_TIME = 480

local width, height
if arg[1] == nil then
    width = 9
    height = 9
else 
    width = tonumber(arg[1])
    height = tonumber(arg[2])
    assert(width ~= nil and height ~= nil)
end

local MIN_FUEL = 1000 -- TODO: create function relative to width and height

local function refuel()
    if chest == nil then
        return
    end

    for _ in 1, 4 do
        turtle.suckUp()
    end 

    for slot in 1, 4 do
        turtle.select(slot)
        turtle.refuel()
        turtle.dropUp()
    end

end

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
        refuel()
    end

    turtle.turnRight()
    -- wait for next harvest
    sleep(WAIT_TIME)
end