--Credit: tmaster1000(GitHub) / thrustermaster (Discord)
local M = {}
local meshs = require("common/jbeam/sections/meshs")
local nodePerformanceMod = require('ge/extensions/nodePerformanceMod')
local logtag = "nodePerformanceMod.meshs"
local originalProcess = meshs.process

local function removeProps(vehicle)
    if vehicle.props == nil then return end

    for propKey = #vehicle.props, 1, -1 do
        local prop = vehicle.props[propKey]
        if prop.func ~= 'steering' then
            table.remove(vehicle.props, propKey)
        end
    end
end

local function disableAero(vehicle)
    if vehicle.triangles == nil then return end

    for _, triangle in pairs(vehicle.triangles) do
        triangle.dragCoef = 0
        triangle.skinDragCoef = 0
        triangle.liftCoef = 0
    end
end

meshs.process = function(objID, vehicleObj, vehicle)

    if nodePerformanceMod.playerSpawnProcessing or nodePerformanceMod.playerReloadProcessing then
        log("I", logtag, "Skipping prop and aero removal for player vehicle")
    else
        if nodePerformanceMod.disablePropsLights then
            log("I", logtag, "Removing PropsLights from remote vehicle")
            removeProps(vehicle)
        end
        if nodePerformanceMod.disableAero then
            log("I", logtag, "Disabling Aero for remote vehicle")
            disableAero(vehicle)
        end
    end

    nodePerformanceMod.playerSpawnProcessing = false
    nodePerformanceMod.playerReloadProcessing = false

    originalProcess(objID, vehicleObj, vehicle)
end

M.process = meshs.process

return M