--Credit: Anonymous275(GitHub), thrustermaster(Discord), _N_S_(BeamNG Forums)
--Injects into stage2.lua to modify node collision parameters
local stage2 = require("vehicle/jbeam/stage2")
local abs = math.abs
local wheelNodes = {}

local function nodeCheck(nodeID, vehicle)
    local connectedNodes = {}
    for _, beam in pairs(vehicle.beams) do
        if beam.id1 == nodeID then
            connectedNodes[beam.id2] = 1
        else
            if beam.id2 == nodeID then
                connectedNodes[beam.id1] = 1
            end
        end
    end

    local shellNode = {true, true, true}
    for id, num in  pairs(connectedNodes) do
        if abs(vehicle.nodes[nodeID].pos.x) < abs(vehicle.nodes[id].pos.x) then
            shellNode[0] = false
        end

        if abs(vehicle.nodes[nodeID].pos.y) < abs(vehicle.nodes[id].pos.y) then
            shellNode[1] = false
        end

        if abs(vehicle.nodes[nodeID].pos.z) < abs(vehicle.nodes[id].pos.z) then
            shellNode[2] = false
        end
    end

    return shellNode[0] or shellNode[1] or shellNode[2]
end


do
    local loadVehicleStage2 = stage2.loadVehicleStage2

    stage2.loadVehicleStage2 = function(v)
        stage2.loadVehicleStage2 = loadVehicleStage2

        local isPlayerVehicle = v.config.isPlayerVehicle

        if not isPlayerVehicle then

            local pushToPhysics = ({debug.getupvalue(stage2.loadVehicleStage2, 1)})[2]
            local processNodes  = ({debug.getupvalue(pushToPhysics, 1)})[2]
            local processTriangles  = ({debug.getupvalue(pushToPhysics, 2)})[2]
            debug.setupvalue(pushToPhysics, 1, function(vehicle)

                if vehicle.nodes == nil then return end

                for _, node in pairs(vehicle.nodes) do -- For each node

                    if node.wheelID ~= nil or nodeCheck(node.cid, vehicle) == true or node.couplerTag ~= nil or node.tag ~= nil then -- If it's a wheel or on the outer shell or part of a coupler system
                        goto continue
                    end
                    node.collision = false --disable all collision
                    ::continue::
                    if node.selfCollision ~= nil then --disable selfcollision anyway
                        node.selfCollision = false
                    end
                end

                debug.setupvalue(pushToPhysics, 1, processNodes)
                return processNodes(vehicle)
            end)

            debug.setupvalue(pushToPhysics, 2, function(vehicle)

                if vehicle.triangles == nil then return end

                for _, triangle in pairs(vehicle.triangles) do

                    if triangle.liftCoef ~= nil then
                        triangle.liftCoef = 0
                    end

                    if triangle.dragCoef ~= nil then
                        triangle.dragCoef = 0
                    end

                    if triangle.stallAngle ~= nil then
                        triangle.stallAngle = 0
                    end

                    if triangle.skinDragCoef ~= nil then
                        triangle.skinDragCoef = 0
                    end

                end
                debug.setupvalue(pushToPhysics, 1, processTriangles)
                return processTriangles(vehicle)
            end)
            print("Partially disabled collisions and aero for non-player vehicle " .. tostring(obj:getID()))
        else












            print("Skipped aerodynamics and collision disabling for player vehicle")
        end

        return loadVehicleStage2(v)
    end
end

return stage2