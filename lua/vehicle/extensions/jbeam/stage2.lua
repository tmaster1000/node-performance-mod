-- Credit: Anonymous275(GitHub), thrustermaster(Discord), _N_S_(BeamNG Forums)
-- Injects into stage2.lua to modify node collision parameters
local stage2 = require("vehicle/jbeam/stage2")
local perfmodstage2 = require("perfMod/stage2")

do
    local loadVehicleStage2 = stage2.loadVehicleStage2
    stage2.loadVehicleStage2 = function(v)

        stage2.loadVehicleStage2 = loadVehicleStage2
        local pushToPhysics = ({debug.getupvalue(stage2.loadVehicleStage2, 1)})[2]
        local processNodes = ({debug.getupvalue(pushToPhysics, 1)})[2]
        -- local processBeams = ({debug.getupvalue(pushToPhysics, 2)})[2]
        -- local processWheels = ({debug.getupvalue(pushToPhysics, 3)})[2]
        -- local processRails = ({debug.getupvalue(pushToPhysics, 4)})[2]
        -- local processSlidenodes = ({debug.getupvalue(pushToPhysics, 5)})[2]
        -- local processTorsionhydros = ({debug.getupvalue(pushToPhysics, 6)})[2]
        -- local processTorsionbars = ({debug.getupvalue(pushToPhysics, 7)})[2]
        -- local processTriangles = ({debug.getupvalue(pushToPhysics, 8)})[2]
        -- local processRefNodes = ({debug.getupvalue(pushToPhysics, 9)})[2]

        if v.config.isPlayerVehicle then -- player modifications
            debug.setupvalue(pushToPhysics, 1, function(vehicle)

                if vehicle.nodes == nil then
                    return
                end

                for _, node in pairs(vehicle.nodes) do
                    if node.selfCollision ~= nil then
                        node.selfCollision = false
                    end
                end

                debug.setupvalue(pushToPhysics, 1, processNodes)
                return processNodes(vehicle)
            end)
            print("selfCollision disabled for player")
        else -- non player modifications
            debug.setupvalue(pushToPhysics, 1, function(vehicle)

                if vehicle.nodes == nil then
                    return
                end

                for _, node in pairs(vehicle.nodes) do

                    if node.wheelID ~= nil or perfmodstage2.nodeCheck(node.cid, vehicle) == true then
                        goto continue
                    end
                    node.collision = false
                    ::continue::
                    if node.selfCollision ~= nil then
                        node.selfCollision = false
                    end
                end

                debug.setupvalue(pushToPhysics, 1, processNodes)
                return processNodes(vehicle)
            end)
            print("Collision limited for non-player")
        end
        return loadVehicleStage2(v)
    end
end

return stage2
