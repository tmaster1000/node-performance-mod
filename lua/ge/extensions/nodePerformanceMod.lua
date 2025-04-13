-- Credit: tmaster1000(GitHub) / thrustermaster (Discord), _N_S_ (BeamNG Forums), Unshown
--GE LUA player processing is marked with global variables, VE LUA vehicles are marked by setting vehicleConfig values

local M = {}
local settingsPath = '/settings/nodePerformance.json'
M.dependencies = { "ui_imgui" }
local logtag = "nodePerformanceMod"
local ui = ui_imgui

local reduceCollision = M.reduceCollision or true
local disablePropsLights = M.disablePropsLights or false
local disableTires = M.disableTires or false
local disableAero = M.disableAero or false

local playerVehicles = {}
M.playerSpawnProcessing = false
M.playerReloadProcessing = false
M.playerDestroyProcessing = nil
M.dependencies = { "vehicles", 'levels' }
local isLoaded = false

local function isPlayerVehicle(objID)
    if playerVehicles == nil or type(playerVehicles) ~= "table" then
        log("E", logtag, "PlayerVehicles is nil or not a table")
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

    for i = 1, 2 ^ 16 do
        if not debug.getinfo(i) then break end
        local BREAK = false

        for j = 1, 2 ^ 16 do
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

    if vehicleConfig_ == nil or type(vehicleConfig_) ~= "table" then
        log("E", logtag, "VehicleConfig is nil or not a table")
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
        vehicleConfig_.isPlayerVehicle = not M.reduceCollision
    end
end

local function onLoadingScreenFadeout()
    guihooks.trigger('toastrMsg',
        { type = "info", title = "Performance Mod active", msg = "Press F10 for options", config = { timeOut = 5000 } })
end

function onLuaReloaded() -- LUA reloads will clear the table so we attempt to salvage something by setting player vehicle to the current vehicle
    local playerVehicleID = be:getPlayerVehicleID(0)
    if playerVehicleID ~= nil then
        table.insert(playerVehicles, playerVehicleID)
    end
end

local function reloadAllVehicles()
    core_vehicle_manager.reloadAllVehicles()
end

local function settingsSave()
    local s = {
        reduceCollision = reduceCollision,
        disablePropsLights = disablePropsLights,
        disableTires = disableTires,
        disableAero = disableAero
    }
    jsonWriteFile(settingsPath, s, true)
end

local function settingsLoad()
    local s = jsonReadFile(settingsPath)
    if s then
        if s.reduceCollision ~= nil then
            reduceCollision = s.reduceCollision
            M.reduceCollision = reduceCollision
        end
        if s.disablePropsLights ~= nil then
            disablePropsLights = s.disablePropsLights
            M.disablePropsLights = disablePropsLights
        end
        if s.disableTires ~= nil then
            disableTires = s.disableTires
            M.disableTires = disableTires
        end
        if s.disableAero ~= nil then
            disableAero = s.disableAero
            M.disableAero = disableAero
        end
    else
        log("I", logtag, "No saved settings found, using defaults.")
    end
end

---IMGUI
local showUI = ui.BoolPtr(false)

local function renderUI()
    ui.SetNextWindowSize(ui.ImVec2(500, 500), ui.Cond_FirstUseEver)
    if ui.Begin("Performance Mod", showUI, ui.WindowFlags_AlwaysAutoResize) then
        ui.Text("Optimize remote vehicles for more FPS")

        local reduceCollisionPtr = ui.BoolPtr(reduceCollision)
        if ui.Checkbox("Reduce Collisions", reduceCollisionPtr) then
            reduceCollision = reduceCollisionPtr[0]
            M.reduceCollision = reduceCollision
            settingsSave()
        end
        if ui.IsItemHovered() then
            ui.BeginTooltip()
            ui.Text("Reduces node collision for remote vehicles and disables collision with own nodes for all vehicles")
            ui.EndTooltip()
        end

        local disablePropsLightsPtr = ui.BoolPtr(disablePropsLights)
        if ui.Checkbox("Reduce Props and Lights", disablePropsLightsPtr) then
            disablePropsLights = disablePropsLightsPtr[0]
            M.disablePropsLights = disablePropsLights
            settingsSave()
        end
        if ui.IsItemHovered() then
            ui.BeginTooltip()
            ui.Text("Disables headlight flares and leaves headlight glow for remote vehicles ")
            ui.EndTooltip()
        end
        ui.Separator()
        ui.Text("Experimental settings - can cause desync")
        local disableTiresPtr = ui.BoolPtr(disableTires)
        if ui.Checkbox("Disable Tires", disableTiresPtr) then
            disableTires = disableTiresPtr[0]
            M.disableTires = disableTires
            settingsSave()
        end
        if ui.IsItemHovered() then
            ui.BeginTooltip()
            ui.Text("Removes tires and gives hubs tire-like properties for remote vehicles")
            ui.EndTooltip()
        end
        local disableAeroPtr = ui.BoolPtr(disableAero)
        if ui.Checkbox("Disable Aerodynamics", disableAeroPtr) then
            disableAero = disableAeroPtr[0]
            M.disableAero = disableAero
            settingsSave()
        end
        if ui.IsItemHovered() then
            ui.BeginTooltip()
            ui.Text("Disables aerodynamics for remote vehicles")
            ui.EndTooltip()
        end
        ui.Separator()
        ui.Text("Changes will affect all new or reloaded cars automatically - CTRL+SHIFT+R to force reload")
    end
    ui.End()
end

local function onUpdate()
    if showUI[0] then
        renderUI()
    end
end

local function toggleUI()
    showUI[0] = not showUI[0]
end

local function show()
    showUI[0] = true
end

local function hide()
    showUI[0] = false
end

local function onExtensionLoaded()
    settingsLoad()
end

M.onExtensionLoaded = onExtensionLoaded

M.onUpdate = onUpdate
M.toggleUI = toggleUI
M.show = show
M.hide = hide

M.reduceCollision = reduceCollision
M.disablePropsLights = disablePropsLights
M.disableTires = disableTires
M.disableAero = disableAero

M.onSpawnCCallback = onSpawnCCallback
M.playerReloadCheck = playerReloadCheck

M.onLoadingScreenFadeout = onLoadingScreenFadeout

return M
