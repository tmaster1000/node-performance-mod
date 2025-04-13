local M = {}

local function isAmongTopTwo(vehicle, connectedNodes, nodeID, axis)
    local distances = {}
    local nodePos = math.abs(vehicle.nodes[nodeID].pos[axis])

    for id in pairs(connectedNodes) do
        table.insert(distances, math.abs(vehicle.nodes[id].pos[axis]))
    end
    table.insert(distances, nodePos)

    table.sort(distances, function(a, b)
        return a > b
    end)

    for i = 1, math.min(2, #distances) do
        if nodePos == distances[i] then
            -- vehicle.nodes[nodeID].highlight = true
            return true
        end
    end
    return false
end

-- new version, considers top 2 best candidates for shell node instead of previous top 1. Laggier but much better, still disables half the collision
function M.nodeCheck(nodeID, vehicle)
    local connectedNodes = {}
    for i = 1, #vehicle.beams do
        local beam = vehicle.beams[i]
        if beam.id1 == nodeID then
            connectedNodes[beam.id2] = true
        elseif beam.id2 == nodeID then
            connectedNodes[beam.id1] = true
        end
    end

    local shellNode = { true, true, true }

    if not isAmongTopTwo(vehicle, connectedNodes, nodeID, "x") then
        shellNode[1] = false
    end
    if not isAmongTopTwo(vehicle, connectedNodes, nodeID, "y") then
        shellNode[2] = false
    end
    if not isAmongTopTwo(vehicle, connectedNodes, nodeID, "z") then
        shellNode[3] = false
    end

    return shellNode[1] or shellNode[2] or shellNode[3]
end

return M