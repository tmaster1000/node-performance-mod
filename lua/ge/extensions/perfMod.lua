-- Credit: thrustermaster, (Discord) _N_S_ (BeamNG Forums), Unshown
--GE LUA player processing is marked with global variables, VE LUA vehicles are marked by setting vehicleConfig values

local M = {}

--OPTIONS

--Safe to use:
M.reduceCollision = true -- REMOTE VEHICLES: disables all collision for nodes not on the outer shell and self-collision for all nodes. PLAYER VEHICLE: disables self-collision
M.disablePropsLights = true --REMOTE VEHICLES: disables headlight flares and all props except the wheel. Doesn't disable the more special ones, WIP
M.disableParticles = true --REMOTE VEHICLES: Disables collision-based particle effects. Does not disable all particle effects

--Experimental, might cause desync but give the highest performance gain:
M.disableTires = true --REMOTE VEHICLES: removes tires and gives hubs tire-like properties
M.disableAero = false --REMOTE VEHICLES: sets all aerodynamic parameters to 0


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

        if M.disableParticles then
            obj:queueLuaCommand("extensions.load('main')")
        end

    end
end

local function onLoadingScreenFadeout()
    guihooks.trigger('toastrMsg', {type = "info", title = "Performance mod:", msg = "Remote vehicles will be optimized", config = {timeOut = 5000}})
end

function onLuaReloaded() -- LUA reloads will clear the table so we attempt to salvage something by setting player vehicle to the current vehicle

    local playerVehicleID = be:getPlayerVehicleID(0)
    if playerVehicleID ~= nil then
        table.insert(playerVehicles, playerVehicleID)
    end
end

M.onSpawnCCallback = onSpawnCCallback
M.playerReloadCheck = playerReloadCheck

M.onLoadingScreenFadeout = onLoadingScreenFadeout


return M
