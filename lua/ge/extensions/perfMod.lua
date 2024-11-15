-- Credit: thrustermaster, (Discord) _N_S_ (BeamNG Forums), Unshown
--GE LUA player processing is marked with global variables, VE LUA vehicles are marked by setting vehicleConfig values

local M = {}

--options
M.reduceCollision = true -- REMOTE VEHICLES: disables collision for nodes not on the outer shell. PLAYER VEHICLE: disables collision with own nodes
M.disablePropsLights = true --REMOTE VEHICLES: disables headlight flares and all props except the wheel
M.disableAero = true --REMOTE VEHICLES: sets all aerodynamic parameters to 0
M.disableTires = true --REMOTE VEHICLES: removes tires and gives hubs tire-like properties
M.limitLua = false --REMOTE VEHICLES: limits controller update rate from 2000hz to 200hz or 1000hz
------------------------

local playerVehicles = {}
M.playerSpawnProcessing = false
M.playerReloadProcessing = false
M.playerDestroyProcessing = nil
M.dependencies = { "vehicles", 'levels'}
local isLoaded = false

local function isPlayerVehicle(objID)

    if playerVehicles == nil or type(playerVehicles) ~= "table" then
        print("playerVehicles is not a table")
        return false
    end

    for _, id in ipairs(playerVehicles) do
        if id == objID then
            return true
        end
    end
    return false
end

local function playerReloadCheck(objID)
    if M.playerReloadProcessing and isPlayerVehicle(objID) then
        return true
    else
        return false
    end
end

local function onSpawnCCallback(objID)

    if not isLoaded then --spaghetti solution because loading this as a dependency is too early - **THIS BREAKS LUA CTRL+L RELOADS, REMOVE IF MAKING EDITS**
       extensions.load('partmgmt')
        isLoaded = true
    end

    local vehicleConfig_

    for i = 1, 2^16 do
        if not debug.getinfo(i) then break end
        local BREAK = false

        for j = 1, 2^16 do
            local name, value = debug.getlocal(i, j)

            if name == "vehicleConfig" then
                vehicleConfig_ = value
                BREAK = true
                break
            end

            if name == nil then
                break
            end
        end

        if BREAK then break end
    end

    if type(vehicleConfig_) ~= "table" then
        print("Vehicle config not a table")
        return
    end

    local obj = be:getObjectByID(objID)



    if M.playerDestroyProcessing then
        for i, id in ipairs(playerVehicles) do
            if id == objID then
                table.remove(playerVehicles, i)
                --print("Player vehicle destroyed: " .. objID)
                break
            end
        end
        M.playerDestroyProcessing = nil
    end

    if M.playerSpawnProcessing or playerReloadCheck(objID) then
        --print("Player vehicle detected: " .. objID)
        vehicleConfig_.isPlayerVehicle = true
        table.insert(playerVehicles, objID)
    else
        M.playerReloadProcessing = false
        --print("NPC spawned or reloaded: " .. objID)
        if M.reduceCollision then
            vehicleConfig_.isPlayerVehicle = false
        else
            vehicleConfig_.isPlayerVehicle = true
        end

        if M.limitLua then
            print("limiting lua")
            obj:queueLuaCommand("extensions.load('main')")
        end

    end
end

function onLuaReloaded() -- LUA reloads will clear the table so we attempt to salvage something by setting player vehicle to the current vehicle

    local playerVehicleID = be:getPlayerVehicleID(0)
    if playerVehicleID ~= nil then
        table.insert(playerVehicles, playerVehicleID)
    end
end

M.onSpawnCCallback = onSpawnCCallback
M.playerReloadCheck = playerReloadCheck


return M
