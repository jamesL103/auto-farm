
-- move all carrots from plot storage to central storage
local function storeCarrots()
    local farms = peripheral.wrap("top")
    local central = peripheral.wrap("right")
    local chests = { peripheral.find("minecraft:chest")}

    for i, chest in pairs(chests) do
        for slot, item in pairs(chest.list()) do
            if item == nil then
                goto continue
            end
            central.pullItems(peripheral.getName(chest), slot)
            ::continue::
        end
    end
    print("Moved carrots to central storage")
end

if shell and shell.getRunningProgram() == 'store.lua' then
    local cmd = arg[1]
    if cmd == "carrot" then
        storeCarrots()
    else 
        error("Invalid command")
    end
end