if arg[1] == nil then
    error("Specify the number of cauldrons in the lava row.")
end
local cauldrons = arg[1]
local WAIT_TIME = 60
local MIN_FUEL = 200

-- transfer all items from source inventory to destination
local function transferAllItems(src, dest)
    for slot, item in pairs(src.list()) do
        if item == nil then
            goto continue
        end
        src.pushItems(dest.getName(), slot)

        ::continue::
    end
end

-- transfer all items in the turtle to dest inventory, through the buffer inventory
local function transferToInventory(buffer, dest)
    for slot = 1, 16 do
        turtle.select(slot)
        turtle.dropUp()
    end

    transferAllItems(buffer, dest)
end

while true do
    -- wrap chest as peripheral
    local depot = peripheral.wrap("front") -- fuel depot chest
    local buffer = peripheral.wrap("back") -- item transferring buffer chest

    --check own fuel level
    if turtle.getFuelLevel() < MIN_FUEL then
        for slot, item in pairs(depot.list()) do
            if item ~= nil and item.name == "minecraft:lava_bucket" then
                depot.pushItems(buffer.getName(), slot) -- move only one lava bucket for now
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
        transferToInventory(buffer, depot)
    end

    -- wait
    sleep(300)

    -- check depot for empty buckets
    for slot, item in pairs(depot.list()) do
        if item ~= nil and item.name == "minecraft:bucket" then
            depot.pushItems(buffer.getName(), slot) -- move only one lava bucket for now
        end
    end

    -- refuel empty buckets

end
