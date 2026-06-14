-- auto_farm.lua
-- Place turtle one block above the farm, at the bottom left corner
-- The turtle must face up in the farm grid.
-- Usage: auto_farm [width] [height]

local cropSeeds = {
    ["minecraft:wheat"] = "minecraft:wheat_seeds",
    ["minecraft:carrots"] = "minecraft:carrot",
    ["minecraft:potatoes"] = "minecraft:potato",
    ["minecraft:beetroots"] = "minecraft:beetroot_seeds"
}

local function selectSeed(seedName)
    for slot = 1, 16 do
        local item = turtle.getItemDetail(slot)
        if item and item.name == seedName then
            turtle.select(slot)
            return true
        end
    end
    return false
end

local function tryHarvestAndReplant()
    local success, data = turtle.inspectDown()
    if not success or not data then
        return
    end

    local seedName = cropSeeds[data.name]
    if not seedName then
        return
    end

    local state = data.state or {}
    local mature = false

    if data.name == "minecraft:wheat" then
        mature = tonumber(state.age) == 7
    elseif data.name == "minecraft:carrots" then
        mature = tonumber(state.age) == 7
    elseif data.name == "minecraft:potatoes" then
        mature = tonumber(state.age) == 7
    elseif data.name == "minecraft:beetroots" then
        mature = tonumber(state.age) == 3
    end

    if mature then
        turtle.digDown()
        sleep(0.4)

        if selectSeed(seedName) then
            turtle.placeDown()
        end
    end
end

local function forwardOrError()
    local success, msg = turtle.forward()
    if not success then
        error(msg)
    end
end

local function turnAround()
    turtle.turnLeft()
    turtle.turnLeft()
end

local function farmCol()
    for i = 1, height do
        tryHarvestAndReplant()
        if i < height then
            forwardOrError()
        end
    end
end

local function goToNextCol(col)
    if col >= width then
        return
    end

    if col % 2 == 1 then
        turtle.turnRight()
        forwardOrError()
        turtle.turnRight()
    else
        turtle.turnLeft()
        forwardOrError()
        turtle.turnLeft()
    end
end

-- run one farming iteration over the farm
local function auto_farm(width, height)
    for x = 1, width do
        farmCol()
        goToNextCol(x)
    end

    -- Return to starting corner
    if width % 2 == 1 then
        turtle.turnLeft()
    else
        turtle.turnRight()
    end

    for i = 1, width - 1 do
        forwardOrError()
    end

    -- return to start position and original orientation
    if width % 2 == 1 then
        turtle.turnLeft()
        for i = 1, height - 1 do
            forwardOrError()
        end
        turnAround()
    else
        turtle.turnRight()
    end
end

-- run only if main script
if shell and shell.getRunningProgram() == '/auto_farm.lua' then
    local width, height
    if arg[1] == nil then
        width = 9
    end
    if arg[2] == nil then
        height = 9
    end
    width = tonumber(arg[1])
    height = tonumber(arg[2])
    assert(width ~= nil and height ~= nil)
    while true do
        auto_farm(width, height)
        wait(420)
    end
end