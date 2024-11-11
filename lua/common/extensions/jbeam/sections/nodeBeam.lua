--Credit:  thrustermaster (Discord)
--Injects into nodeBeam.lua to alter wheel generation. Done here instead of wheels.lua for convenience.
local M = {}
local nodeBeam = require("common/jbeam/sections/nodeBeam")
local originalProcess = nodeBeam.process
local originalProcessNodes = processNodes
local abs = math.abs
local function simplifyWheels(vehicle)
    if vehicle["pressureWheels"] ~= nil then
    for k, v in pairs(vehicle["pressureWheels"]) do

        v.hasTire = false

        v.numRays = math.floor(v.numRays / 1.6 + 0.5)
        if v.numRays % 2 ~= 0 then
            v.numRays = v.numRays + 1
        end

        v.triangleCollision = false
        v.selfCollision = false
        v.dragCoef = 0

        v.hubRadiusSimple = v.hubRadius
        v.hubRadius = v.radius
        v.hubWidth = v.tireWidth
        v.hubFrictionCoef = v.frictionCoef
        v.hubNodeMaterial = v.nodeMaterial

        v.hubBeamSpring = v.wheelSideBeamSpring
        v.hubBeamDamp = v.wheelSideBeamDamp
        v.hubBeamDeform = v.wheelSideBeamDeform * 10
        v.hubBeamStrength = v.wheelSideBeamStrength * 10

        v.hubTreadBeamSpring = v.wheelTreadBeamSpring
        v.hubTreadBeamDamp = v.wheelTreadBeamDamp

        v.hubPeripheryBeamSpring = v.wheelPeripheryBeamSpring
        v.hubPeripheryBeamDamp = v.wheelPeripheryBeamDamp

        v.hubReinfBeamSpring = v.hubReinfBeamSpring
        v.hubReinfBeamDamp = v.hubReinfBeamSpring

        v.hubTreadBeamDeform = nil
        v.hubTreadBeamStrength = nil
        v.hubPeripheryBeamDeform = nil
        v.hubPeripheryBeamStrength = nil
        v.hubReinfBeamDeform = nil
        v.hubReinfBeamStrength = nil

    end

    else
        print("vehicle[pressureWheels] is nil")
    end
end

nodeBeam.process = function(vehicle)
   if perfMod.playerSpawnProcessing or perfMod.playerReloadProcessing then
        --simplifyWheels(vehicle)
        print("Skipping wheel simplifying for player vehicle")
  else
        simplifyWheels(vehicle)
        print("Applied wheel simplifying for non-player vehicle")
  end
   perfMod.playerSpawnProcessing = false
   perfMod.playerReloadProcessing = false

    originalProcess(vehicle)  -- Call the original process, which now includes the modified processNodes
end

M.process = nodeBeam.process

return M
