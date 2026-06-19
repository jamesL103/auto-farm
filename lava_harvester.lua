if arg[1] == nil then
    error("Specify the number of cauldrons in the lava row.")
end
local cauldrons = arg[1]
local WAIT_TIME = 60
local MIN_FUEL = 200

-- transfer all items to inventory in front
local function transferAllItems()
    for slot = 1, 16 do
        turtle.select(slot)
        turtle.drop()
    end
end

local function return_to_start()
    local front_block = turtle.inspect()
    local up_block = turtle.inspectUp()
    turtle.turnRight()
    while front_block.name == "minecraft:chest" and up_block.name == "minecraft:chest" do
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
    end
    turtle.turnLeft()
end

while true do
    -- wrap chest as peripheral
    local depot = peripheral.wrap("front") -- fuel depot chest
    local buffer = peripheral.wrap("top") -- item transferring buffer chest

    --check own fuel level
    if turtle.getFuelLevel() < MIN_FUEL then
        for slot, item in pairs(depot.list()) do
            if item ~= nil and item.name == "minecraft:lava_bucket" then
                depot.pushItems(peripheral.getName(buffer), slot) -- move only one lava bucket for now
            end
        end

        turtle.suckUp() -- one bucket

        for slot = 1, 16 do
            turtle.select(slot)
            if turtle.refuel(0) then
                turtle.refuel(64)
            end
            if turtle.getFuelLevel() >= MIN_FUEL then
                break
            end
        end
        transferAllItems()
    end

    -- wait
    -- sleep(WAIT_TIME)

    -- check depot for empty buckets
    for slot, item in pairs(depot.list()) do
        if item ~= nil and item.name == "minecraft:bucket" then
            depot.pushItems(peripheral.getName(buffer), slot)
        end
    end
    turtle.suckUp()

    -- get number of empty buckets
    local empty_buckets = 0
    for slot = 1, 16 do
        if turtle.getItemDetail(slot).name == "minecraft:bucket" then
            empty_buckets = empty_buckets + 1
        end
    end
    if empty_buckets > 0 then
        turtle.turnLeft()
    end
    -- refuel empty buckets
    for i = 1, cauldrons do
        -- check if empty buckets left in inventory
        if empty_buckets <= 0 then
            break
        end
        turtle.forward()
        turtle.turnLeft()
        turtle.place()
        turtle.turnRight()
        empty_buckets = empty_buckets - 1
        if empty_buckets <= 0 then
            break
        end
        turtle.turnRight()
        turtle.place()
        turtle.turnLeft()
        empty_buckets = empty_buckets - 1
    end
    return_to_start()

    transferAllItems()
end
