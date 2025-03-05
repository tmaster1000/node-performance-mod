local M = {}
local meshs = require("common/jbeam/sections/meshs")
local beamsharpPerformance = require('ge/extensions/beamsharpPerformance')
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

    if beamsharpPerformance.playerSpawnProcessing or beamsharpPerformance.playerReloadProcessing then
        print("Skipping prop and aero removal for player vehicle")
    else
        if beamsharpPerformance.disablePropsLights then
            print("removing props")
            removeProps(vehicle)
        end
        if beamsharpPerformance.disableAero then
            print("disabling aero")
            disableAero(vehicle)
        end
    end

    beamsharpPerformance.playerSpawnProcessing = false
    beamsharpPerformance.playerReloadProcessing = false

    originalProcess(objID, vehicleObj, vehicle)
end


M.process = meshs.process

return M