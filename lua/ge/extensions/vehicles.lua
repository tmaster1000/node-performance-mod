--Credit: tmaster1000(GitHub) / thrustermaster (Discord), Unshown
--Handles all player vehicle spawns/reloads except default vehicle spawn at scenario start (see levels.lua)
local M = {}
local spawnNewVehOrig = core_vehicles.spawnNewVehicle
local replaceVehOrig = core_vehicles.replaceVehicle
local reloadVehOrig = core_vehicles.reloadVehicle
local defaultVehOrig = core_vehicles.loadDefaultVehicle
local cloneVehOrig = core_vehicles.cloneCurrent
local destroyVehOrig = core_vehicles.onVehicleDestroyed
local nodePerformanceMod = require('nodePerformanceMod')

core_vehicles.spawnNewVehicle = function(model, opt)
    nodePerformanceMod.playerSpawnProcessing = true
    return spawnNewVehOrig(model, opt)
end

core_vehicles.replaceVehicle = function(model, opt, otherVeh)
    nodePerformanceMod.playerSpawnProcessing = true
    return replaceVehOrig(model, opt, otherVeh)
end

core_vehicles.reloadVehicle = function(playerid)
    nodePerformanceMod.playerReloadProcessing = true
    return reloadVehOrig(playerid)
end

core_vehicles.onVehicleDestroyed = function(id)
    nodePerformanceMod.playerDestroyProcessing = id
    return destroyVehOrig(id)
end

core_vehicles.loadDefaultVehicle = function(id)
    nodePerformanceMod.playerSpawnProcessing = true
    return defaultVehOrig(id)
end

core_vehicles.cloneCurrent = function()
    nodePerformanceMod.playerSpawnProcessing = true
    return cloneVehOrig()
end

--public interface
M.getCurrentVehicleDetails = core_vehicles.getCurrentVehicleDetails
M.getVehicleDetails = core_vehicles.getVehicleDetails

M.getModel = core_vehicles.getModel
M.openSelectorUI = core_vehicles.openSelectorUI
M.requestList = core_vehicles.notifyUI
M.requestListEnd = core_vehicles.notifyUIEnd
M.getModelList = core_vehicles.getModelList
M.getConfigList = core_vehicles.getConfigList
M.getConfig = core_vehicles.getConfig

M.replaceVehicle = core_vehicles.replaceVehicle
M.spawnNewVehicle = core_vehicles.spawnNewVehicle
M.removeCurrent = core_vehicles.removeCurrent
M.cloneCurrent = core_vehicles.cloneCurrent
M.removeAll = core_vehicles.removeAll
M.removeAllExceptCurrent = core_vehicles.removeAllExceptCurrent
M.removeAllWithProperty = core_vehicles.removeAllWithProperty
M.clearCache = core_vehicles.clearCache


-- used to delete the cached data
M.onFileChanged = core_vehicles.onFileChanged
M.onFileChangedEnd = core_vehicles.onFileChangedEnd
M.onSettingsChanged = core_vehicles.onSettingsChanged

-- License plate
M.setPlateText = core_vehicles.setPlateText
M.getVehicleLicenseText = core_vehicles.getVehicleLicenseText
M.makeVehicleLicenseText = core_vehicles.makeVehicleLicenseText
M.regenerateVehicleLicenseText = core_vehicles.regenerateVehicleLicenseText

M.reloadVehicle = core_vehicles.reloadVehicle

-- Default Vehicle
M.loadDefaultVehicle  = core_vehicles.loadDefaultVehicle
M.loadCustomVehicle   = core_vehicles.loadCustomVehicle
M.spawnDefault        = core_vehicles.spawnDefault
M.loadMaybeVehicle    = core_vehicles.loadMaybeVehicle

M.onVehicleDestroyed = core_vehicles.onVehicleDestroyed

-- ui2
M.getVehicleList = core_vehicles.getVehicleList

M.changeMeshVisibility = core_vehicles.changeMeshVisibility
M.setMeshVisibility = core_vehicles.setMeshVisibility

M.convertVehicleInfo = core_vehicles.convertVehicleInfo

return M
