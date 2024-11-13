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

        local tireFactor = (v.radius - v.hubRadius) / v.radius --attempts to compensate for the missing tire
        local hubFactor = 1 - tireFactor


        v.hasTire = false
        v.numRays = math.floor(v.numRays / 1.6 + 0.5)
        if v.numRays % 2 ~= 0 then
            v.numRays = v.numRays + 1
        end

        v.triangleCollision = false
        v.selfCollision = false

        v.hubRadiusSimple = v.hubRadius
        v.hubRadius = v.radius
        v.hubWidth = v.tireWidth
        v.hubFrictionCoef = v.frictionCoef * 2 --double this to reduce desync wheelspin
        v.hubNodeMaterial = v.nodeMaterial
        v.hubTreadBeamSpring = v.wheelTreadBeamSpring;
        v.hubTreadBeamDamp = v.wheelTreadBeamDamp;

        --constants taken from simplified bastion

        v.hubSideBeamDeform = (v.hubSideBeamDeform or 75568.343750) * hubFactor + (v.wheelSideBeamDeform or 75568.343750) * tireFactor
        v.hubSideBeamStrength = (v.hubSideBeamStrength or 85626.000000) * hubFactor + (v.wheelSideBeamStrength or 85626.000000) * tireFactor
        v.hubSideBeamSpring = math.floor(((v.hubSideBeamSpring or 251000) * hubFactor + (v.wheelSideBeamSpring or 251000) * tireFactor) * 0.7)  --multiply by 0.7 to reduce desync wheelspin
        v.hubSideBeamDamp = math.floor(((v.hubSideBeamDamp or 200) * hubFactor + (v.wheelSideBeamDamp or 200) * tireFactor) * 100 + 0.5) / 100
        v.hubPeripheryBeamSpring = ((v.hubPeripheryBeamSpring or 301000) * hubFactor + (v.wheelPeripheryBeamSpring or 301000) * tireFactor)
        v.hubPeripheryBeamDamp = ((v.hubPeripheryBeamDamp or 150) * hubFactor + (v.wheelPeripheryBeamDamp or 150) * tireFactor)

       v.hubReinfBeamSpring = v.wheelReinfBeamSpring
       v.hubReinfBeamDamp = v.wheelReinfBeamDamp


        v.hubNodeWeight = v.hubNodeWeight + v.nodeWeight

        v.hubBeamDeform = 75568.343750
        v.hubBeamStrength = 85626

    end

    else
        print("vehicle[pressureWheels] is nil")
    end
end

nodeBeam.process = function(vehicle)
   if perfMod.playerSpawnProcessing or perfMod.playerReloadProcessing then

      print("Skipping wheel simplifying for player vehicle")
  else
      simplifyWheels(vehicle)
      print("Applied wheel simplifying for non-player vehicle")
  end
   perfMod.playerSpawnProcessing = false
   perfMod.playerReloadProcessing = false

    originalProcess(vehicle)
end

M.process = nodeBeam.process

return M
