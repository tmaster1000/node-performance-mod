--Credit: Anonymous275(GitHub), thrustermaster(Discord), _N_S_(BeamNG Forums)
--Injects into stage2.lua to modify node collision parameters
local stage2 = require("vehicle/jbeam/stage2")
local abs = math.abs

--new version, considers top 2 best candidates for shell node instead of previous top 1. Laggier but much better, still disables half the collision
local function nodeCheck(nodeID, vehicle)
    local connectedNodes = {}
    for i = 1, #vehicle.beams do
        local beam = vehicle.beams[i]
        if beam.id1 == nodeID then
            connectedNodes[beam.id2] = true
        elseif beam.id2 == nodeID then
            connectedNodes[beam.id1] = true
        end
    end

    local shellNode = {true, true, true}
    local distances = {}
    local function isAmongTopTwo(nodeID, axis)
        for k in pairs(distances) do distances[k] = nil end -- Clear table
        local nodePos = math.abs(vehicle.nodes[nodeID].pos[axis])

        for id in pairs(connectedNodes) do
            table.insert(distances, math.abs(vehicle.nodes[id].pos[axis]))
        end
        table.insert(distances, nodePos)

        table.sort(distances, function(a, b) return a > b end)

        for i = 1, math.min(2, #distances) do
            if nodePos == distances[i] then
                --vehicle.nodes[nodeID].highlight = true
                return true
            end
        end
        return false
    end

    if not isAmongTopTwo(nodeID, "x") then
        shellNode[1] = false
    end
    if not isAmongTopTwo(nodeID, "y") then
        shellNode[2] = false
    end
    if not isAmongTopTwo(nodeID, "z") then
        shellNode[3] = false
    end

    return shellNode[1] or shellNode[2] or shellNode[3]
end



do
    local loadVehicleStage2 = stage2.loadVehicleStage2
    stage2.loadVehicleStage2 = function(v)

        stage2.loadVehicleStage2 = loadVehicleStage2
        local pushToPhysics = ({debug.getupvalue(stage2.loadVehicleStage2, 1)})[2]
        local processNodes = ({debug.getupvalue(pushToPhysics, 1)})[2]
        --local processBeams = ({debug.getupvalue(pushToPhysics, 2)})[2]
        --local processWheels = ({debug.getupvalue(pushToPhysics, 3)})[2]
        --local processRails = ({debug.getupvalue(pushToPhysics, 4)})[2]
        --local processSlidenodes = ({debug.getupvalue(pushToPhysics, 5)})[2]
        --local processTorsionhydros = ({debug.getupvalue(pushToPhysics, 6)})[2]
       -- local processTorsionbars = ({debug.getupvalue(pushToPhysics, 7)})[2]
       --local processTriangles = ({debug.getupvalue(pushToPhysics, 8)})[2]
        --local processRefNodes = ({debug.getupvalue(pushToPhysics, 9)})[2]

        if  v.config.isPlayerVehicle then --player modifications
            debug.setupvalue(pushToPhysics, 1, function(vehicle)

                if vehicle.nodes == nil then return end

                for _, node in pairs(vehicle.nodes) do
                    if node.selfCollision ~= nil then
                        node.selfCollision = false
                    end
                end

                debug.setupvalue(pushToPhysics, 1, processNodes)
                return processNodes(vehicle)
            end)
        print("selfCollision disabled for player")
        else --non player modifications
            debug.setupvalue(pushToPhysics, 1, function(vehicle)

                if vehicle.nodes == nil then return end

                for _, node in pairs(vehicle.nodes) do

                    if node.wheelID ~= nil or nodeCheck(node.cid, vehicle) == true then
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