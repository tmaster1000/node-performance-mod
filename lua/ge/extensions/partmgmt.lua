local M = {}
local setPartsOrig = core_vehicle_partmgmt.setPartsConfig
local setConfigVarsOrig = core_vehicle_partmgmt.setConfigVars

core_vehicle_partmgmt.setPartsConfig = function(...) --parts changed
    perfMod.playerSpawnProcessing = true
    setPartsOrig(...)
end

core_vehicle_partmgmt.setConfigVars = function(...) --tuning changed
    perfMod.playerSpawnProcessing = true
    setConfigVarsOrig(...)
end

-- public interface
M.getVehPartsData = core_vehicle_partmgmt.getVehPartsData
M.save = core_vehicle_partmgmt.savePartConfigFile
M.savePartConfigFileStage2 = core_vehicle_partmgmt.savePartConfigFileStage2_Format3

M.setHighlightedPartsVisiblity = core_vehicle_partmgmt.setHighlightedPartsVisiblity
M.changeHighlightedPartsVisiblity = core_vehicle_partmgmt.changeHighlightedPartsVisiblity
M.highlightParts = core_vehicle_partmgmt.highlightParts
M.selectParts = core_vehicle_partmgmt.selectParts
M.setNewParts = core_vehicle_partmgmt.setNewParts
M.showHighlightedParts = core_vehicle_partmgmt.showHighlightedParts
M.clearVehicleHighlights = core_vehicle_partmgmt.clearVehicleHighlights
M.resetVehicleHighlights = core_vehicle_partmgmt.resetVehicleHighlights
M.setConfig = core_vehicle_partmgmt.setConfig
M.setConfigPaints = core_vehicle_partmgmt.setConfigPaints
M.setConfigVars = core_vehicle_partmgmt.setConfigVars
M.setPartsConfig = core_vehicle_partmgmt.setPartsConfig
M.getConfig = core_vehicle_partmgmt.getConfig
M.onSerialize = core_vehicle_partmgmt.onSerialize
M.onDeserialized = core_vehicle_partmgmt.onDeserialized
M.resetConfig = core_vehicle_partmgmt.resetConfig
M.reset = core_vehicle_partmgmt.reset
M.sendDataToUI = core_vehicle_partmgmt.sendDataToUI
M.vehicleResetted = core_vehicle_partmgmt.vehicleResetted
M.getConfigSource = core_vehicle_partmgmt.getConfigSource
M.getConfigList = core_vehicle_partmgmt.getConfigList
M.openConfigFolderInExplorer = core_vehicle_partmgmt.openConfigFolderInExplorer
M.loadLocal = core_vehicle_partmgmt.loadLocal
M.removeLocal = core_vehicle_partmgmt.removeLocal
M.resetAllToLoadedConfig = core_vehicle_partmgmt.resetAllToLoadedConfig
M.resetPartsToLoadedConfig = core_vehicle_partmgmt.resetPartsToLoadedConfig
M.resetVarsToLoadedConfig = core_vehicle_partmgmt.resetVarsToLoadedConfig
M.saveLocal = core_vehicle_partmgmt.saveLocal
M.saveLocalScreenshot = core_vehicle_partmgmt.saveLocalScreenshot
M.saveLocalScreenshot_stage2 = core_vehicle_partmgmt.saveLocalScreenshot_stage2
M.savedefault = core_vehicle_partmgmt.savedefault
M.hasAvailablePart = core_vehicle_partmgmt.hasAvailablePart
M.setSkin = core_vehicle_partmgmt.setSkin
M.findAttachedVehicles = core_vehicle_partmgmt.findAttachedVehicles

M.onCouplerAttached = core_vehicle_partmgmt.onCouplerAttached
M.onCouplerDetached = core_vehicle_partmgmt.onCouplerDetached

M.buildConfigFromString = core_vehicle_partmgmt.buildConfigFromString
return M
