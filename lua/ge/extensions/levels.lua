 --Marks default vehicle processing on scenario starts

local M = {}
local defaultVehOrig = core_levels.maybeLoadDefaultVehicle

core_levels.maybeLoadDefaultVehicle = function()

    local isMPSession = MPCoreNetwork and MPCoreNetwork.isMPSession and MPCoreNetwork.isMPSession()
    if not isMPSession then
        perfMod.playerSpawnProcessing = true
    end

    defaultVehOrig()
end
M.onGetRawPoiListForLevel = onGetRawPoiListForLevel

M.levelsDir = '/levels/' -- backward compatibility

M.onFilesChanged         = onFilesChanged
M.onClientPostStartMission = onClientPostStartMission
M.maybeLoadDefaultVehicle = maybeLoadDefaultVehicle
M.requestData           = notifyUI
M.startLevel            = startLevel
M.expandMissionFileName = expandMissionFileName
M.getLevelName          = getLevelName
M.getLevelPaths         = getLevelPaths

M.getList        = getList
M.getLevelNames  = getLevelNames
M.getSimpleList  = getLevelNames
M.getLevelByName = getLevelByName

return M
