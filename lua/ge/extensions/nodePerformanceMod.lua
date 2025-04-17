-- Credit: tmaster1000(GitHub) / thrustermaster (Discord), _N_S_ (BeamNG Forums), Unshown
--GE LUA player processing is marked with global variables, VE LUA vehicles are marked by setting vehicleConfig values

local M = {}
local settingsPath = '/settings/nodePerformance.json'
M.dependencies = { "ui_imgui", "vehicles", "levels" }
local logtag = "nodePerformanceMod"
local ui = ui_imgui

local reduceCollision = M.reduceCollision or true
local disablePropsLights = M.disablePropsLights or false
local disableTires = M.disableTires or false
local disableAero = M.disableAero or false
local disableParticles = M.disableParticles or false
local limitNumrays = M.limitNumrays or false
local disableMapLights   = M.disableMapLights   or false

local playerVehicles = {}
M.playerSpawnProcessing = false
M.playerReloadProcessing = false
M.playerDestroyProcessing = nil

local isLoaded = false

local removedLights = {}

local function getFields(objectId)
    local obj = Sim.findObjectById(objectId)
    if obj then
        return obj:getFieldsForEditor()
    end
    return nil
end

local function removeMapLights()
    removedLights = {}

    local function recurse(grp)
        grp = Sim.upcast(grp)
        if not grp then return end

        for i = grp:size() - 1, 0, -1 do
            local child = grp:at(i)
            if not child then
                -- nothing
            else
                local cid = child:getID()
                local fields = getFields(cid)

                if fields then

                    local hasLightGroup = false
                    for _, finfo in pairs(fields) do
                        if finfo.groupName == "Light" then
                            hasLightGroup = true
                            break
                        end
                    end

                    if hasLightGroup then

                        local dump = "[" .. child:serializeForEditor(true, -1, "") .. "]"
                        table.insert(removedLights, {
                            json     = dump,
                            parentID = grp:getID(),
                            forcedID = cid,
                        })
                        child:deleteObject()
                    elseif child:isSubClassOf("SimSet") then
                        recurse(child)
                    end
                elseif child:isSubClassOf("SimSet") then
                    recurse(child)
                end
            end
        end
    end

    recurse(Sim.getRootGroup())
end

local function restoreMapLights()
    for _, info in ipairs(removedLights) do
        SimObject.setForcedId(info.forcedID)
        local parent = scenetree.findObjectById(info.parentID)
        Sim.deserializeObjectsFromText(info.json, true, true)
    end
    removedLights = {}
end

local function toggleMapLights(off)
    if off then removeMapLights() else restoreMapLights() end
end

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
        obj:queueLuaCommand("particlefilter.setSkipNodeCollision(" .. tostring(M.disableParticles) .. ")")
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
        disableAero = disableAero,
        disableParticles = disableParticles,
        limitNumrays =  limitNumrays,
        disableMapLights   = false --doesn't persist yet, should probably use onScenarioLoaded or something
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
        if s.disableParticles ~= nil then
           disableParticles = s.disableParticles
            M.disableParticles = disableParticles
        end
        if s.limitNumrays ~= nil then
           limitNumrays = s.limitNumrays
            M.limitNumrays = limitNumrays
        end
        if s.disableMapLights ~= nil then
            disableMapLights = s.disableMapLights
            M.disableMapLights = disableMapLights
            toggleMapLights(disableMapLights)
        end
    else
        log("I", logtag, "No saved settings found, using defaults.")
    end
end

---IMGUI
local showUI = ui.BoolPtr(false)

local function renderUI()
    ui.SetNextWindowSize(ui.ImVec2(500, 500), ui.Cond_FirstUseEver)
    if ui.Begin("Node Performance Mod v3 by tmaster1000", showUI, ui.WindowFlags_AlwaysAutoResize) then
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
       local disableParticlesPtr = ui.BoolPtr(disableParticles)
         if ui.Checkbox("Disable Collision Particles", disableParticlesPtr) then
             disableParticles = disableParticlesPtr[0]
             M.disableParticles = disableParticles
             settingsSave()
         end
         if ui.IsItemHovered() then
             ui.BeginTooltip()
             ui.Text("Disables collision particles for remote vehicles")
             ui.EndTooltip()
         end
         local ptPtr = ui.BoolPtr(disableMapLights)
         if ui.Checkbox("Remove Map Lights (not persistent)", ptPtr) then
             disableMapLights = ptPtr[0]
             M.disableMapLights = disableMapLights
             toggleMapLights(disableMapLights)
             settingsSave()
         end
         if ui.IsItemHovered() then
             ui.BeginTooltip()
               ui.Text("Removes all light objects from the map NOTE: Setting does not persist - you have to enable it every time")
             ui.EndTooltip()
         end
        ui.Separator()
        ui.Text("Experimental settings - can cause desync")
        local limitNumraysPtr = ui.BoolPtr(limitNumrays)
        if ui.Checkbox("Limit wheel complexity", limitNumraysPtr) then
            limitNumrays = limitNumraysPtr[0]
            M.limitNumrays = limitNumrays
            settingsSave()
        end
        if ui.IsItemHovered() then
            ui.BeginTooltip()
            ui.Text("Reduces wheel complexity for remote vehicles")
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
        local disableTiresPtr = ui.BoolPtr(disableTires)
        if ui.Checkbox("Disable Tires (for desperate people)", disableTiresPtr) then
            disableTires = disableTiresPtr[0]
            M.disableTires = disableTires
            settingsSave()
        end
        if ui.IsItemHovered() then
            ui.BeginTooltip()
            ui.Text("Removes tires and gives hubs tire-like properties for remote vehicles")
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
M.disableParticles = disableParticles
M.reduceCollision = reduceCollision
M.disablePropsLights = disablePropsLights
M.disableTires = disableTires
M.disableAero = disableAero
M.disableMapLights = disableMapLights

M.onSpawnCCallback = onSpawnCCallback
M.playerReloadCheck = playerReloadCheck

M.onLoadingScreenFadeout = onLoadingScreenFadeout

return M