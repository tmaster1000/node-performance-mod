local M = {}
local meshs = require("common/jbeam/sections/meshs")
local perfMod = require('ge/extensions/perfMod')
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

    if perfMod.playerSpawnProcessing or perfMod.playerReloadProcessing then
        print("Skipping prop and aero removal for player vehicle")
    else
        if perfMod.disablePropsLights then
            print("removing props")
            removeProps(vehicle)
        end
        if perfMod.disableAero then
            print("disabling aero")
            disableAero(vehicle)
        end
    end

    perfMod.playerSpawnProcessing = false
    perfMod.playerReloadProcessing = false

    originalProcess(objID, vehicleObj, vehicle)
end


M.process = meshs.process

return M