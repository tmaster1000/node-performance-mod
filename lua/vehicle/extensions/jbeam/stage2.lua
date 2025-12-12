-- Credit: tmaster1000 / thrustermaster, thanks Anonymous275 for the idea

local stage2 = require("vehicle/jbeam/stage2")
local abs = math.abs
local logtag = "nodePerformanceMod.meshs"

local function countCArray(t)
  if tableSizeC then return tableSizeC(t) end
  local maxk = -1
  for k in pairs(t or {}) do
    if type(k) == "number" and k > maxk then maxk = k end
  end
  return maxk + 1
end

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

  local shellNode = { true, true, true }
  local distances = {}

  local function isAmongTopTwo(localNodeID, axis)
    for k in pairs(distances) do distances[k] = nil end
    local nodePos = abs(vehicle.nodes[localNodeID].pos[axis])

    for id in pairs(connectedNodes) do
      table.insert(distances, abs(vehicle.nodes[id].pos[axis]))
    end
    table.insert(distances, nodePos)

    table.sort(distances, function(a, b) return a > b end)

    for i = 1, math.min(2, #distances) do
      if nodePos == distances[i] then
        return true
      end
    end
    return false
  end

  if not isAmongTopTwo(nodeID, "x") then shellNode[1] = false end
  if not isAmongTopTwo(nodeID, "y") then shellNode[2] = false end
  if not isAmongTopTwo(nodeID, "z") then shellNode[3] = false end

  return shellNode[1] or shellNode[2] or shellNode[3]
end

local function disableSelfCollisionIfPresent(vehicle)
  if not vehicle or not vehicle.nodes then return end
  local nCount = countCArray(vehicle.nodes)
  for i = 0, nCount - 1 do
    local node = vehicle.nodes[i]
    if node and node.selfCollision ~= nil then
      node.selfCollision = false
    end
  end
end

local function limitRemoteVehicleCollision(vehicle)
  if not vehicle or not vehicle.nodes or not vehicle.beams then return end
  local nCount = countCArray(vehicle.nodes)

  for i = 0, nCount - 1 do
    local node = vehicle.nodes[i]
    if node then
      if node.wheelID ~= nil or nodeCheck(node.cid, vehicle) == true then
        goto continue
      end
      node.collision = false
      ::continue::
      if node.selfCollision ~= nil then
        node.selfCollision = false
      end
    end
  end
end

do
  local origLoadVehicleStage2 = stage2.loadVehicleStage2

  stage2.loadVehicleStage2 = function(vdataStage1)
    stage2.loadVehicleStage2 = origLoadVehicleStage2

    local v = vdataStage1 and vdataStage1.vdata
    local cfg = vdataStage1 and vdataStage1.config

    if v and cfg then
      if cfg.isPlayerVehicle then
        disableSelfCollisionIfPresent(v)
        log("I", logtag, "Disabled Self-Collision for player vehicle")
      else
        limitRemoteVehicleCollision(v)
        log("I", logtag, "Collision limited for remote vehicle")
      end
    end

    return origLoadVehicleStage2(vdataStage1)
  end
end

return stage2