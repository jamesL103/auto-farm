
-- move all carrots from plot storage to central storage
local function storeCarrots(carrotCentral)
    local central = peripheral.wrap(carrotCentral)
    local chests = { peripheral.find("minecraft:chest")}

    for i, chest in pairs(chests) do
        if chest.name == carrotCentral then
            goto skip_central
        end

        for slot, item in pairs(chest.list()) do
            if item == nil then
                goto continue
            end
            central.pullItems(peripheral.getName(chest), slot)
            ::continue::
        end
        ::skip_central::
    end
    print("Moved carrots to central storage")
end

if shell and shell.getRunningProgram() == 'store.lua' then
    -- Get the JSON config file
    local file = io.open('storage.json')
    local config = textutils.unserializeJSON(file.read("a"))

    local cmd = arg[1]
    if cmd == "carrot" then
        storeCarrots(config.carrot_central)
    else 
        error("Invalid command")
    end
    io.close(file)
end