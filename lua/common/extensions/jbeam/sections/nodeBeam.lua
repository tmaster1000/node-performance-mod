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

        v.hubRadiusSimple = v.hubRadius
        v.hubRadius = v.radius
        v.hubWidth = v.tireWidth
        v.hubFrictionCoef = v.frictionCoef
        v.hubNodeMaterial = v.nodeMaterial

        v.hubBeamSpring = v.wheelSideBeamSpring
        v.hubBeamDamp = v.wheelSideBeamDamp
        v.hubBeamDeform = v.wheelSideBeamDeform
        v.hubBeamStrength = v.wheelSideBeamStrength

        v.hubTreadBeamSpring = v.wheelTreadBeamSpring
        v.hubTreadBeamDamp = v.wheelTreadBeamDamp
        v.hubTreadBeamDeform = v.wheelTreadBeamDeform
        v.hubTreadBeamStrength = v.wheelTreadBeamStrength

        v.hubPeripheryBeamSpring = v.wheelPeripheryBeamSpring
        v.hubPeripheryBeamDamp = v.wheelPeripheryBeamDamp
        v.hubPeripheryBeamDeform = v.wheelPeripheryBeamDeform
        v.hubPeripheryBeamStrength = v.wheelPeripheryBeamStrength

        v.hubReinfBeamSpring = v.wheelSideReinfBeamSpring
        v.hubReinfBeamDamp = v.wheelSideReinfBeamDamp
        v.hubReinfBeamDeform = v.wheelSideReinfBeamDeform
        v.hubReinfBeamStrength = v.wheelSideReinfBeamStrength

        v.hubNodeWeight = v.hubNodeWeight + v.nodeWeight

        v.triangleCollision = false
        v.selfCollision = false
        v.collision = true
        v.disableHubMeshBreaking = false
        v.disableMeshBreaking = false
        v.enableBrakeThermals = false
        v.enableTireLbeams = false
        v.enableTirePeripheryReinfBeams = false
        v.enableTireReinfBeams = false
        v.enableTireSideReinfBeams = false
        v.enableTreadReinfBeams = false
        v.enableExtraHubcapBeams = false
        v.enableHubcaps = false
        v.disableTriangleBreaking = false
        v.dragCoef = 0
        v.enableABS = nil
        v.frictionCoef = nil
        v.fullLoadCoef = nil
        v.hubcapAttachBeamDamp = nil
        v.hubcapAttachBeamDeform = nil
        v.hubcapAttachBeamSpring = nil
        v.hubcapAttachBeamStrength = nil
        v.hubcapBeamDamp = nil
        v.hubcapBeamDeform = nil
        v.hubcapBeamSpring = nil
        v.hubcapBeamStrength = nil
        v.hubcapCenterNodeWeight = nil
        v.hubcapCollision = nil
        v.hubcapFrictionCoef = nil
        v.hubcapNodeMaterial = nil
        v.hubcapNodeWeight = nil
        v.hubcapOffset = nil
        v.hubcapRadius = nil
        v.hubcapSelfCollision = nil
        v.hubcapSupportBeamDeform = nil
        v.hubcapSupportBeamStrength = nil
        v.hubcapWidth = nil
        v.loadSensitivitySlope = nil
        v.noLoadCoef = nil
        v.nodeMaterial = nil
        --v.nodeWeight = nil
        v.padGlazingSusceptibility = nil
        v.pressurePSI = nil
        v.skinName = nil
        v.slidingFrictionCoef = nil
        v.squealCoefLowSpeed = nil
        v.squealCoefNatural = nil
        v.tireWidth = nil
        v.wheelPeripheryBeamDamp = nil
        v.wheelPeripheryBeamDampCutoffHz = nil
        v.wheelPeripheryBeamDeform = nil
        v.wheelPeripheryBeamPrecompression = nil
        v.wheelPeripheryBeamSpring = nil
        v.wheelPeripheryBeamStrength = nil
        v.wheelPeripheryReinfBeamDamp = nil
        v.wheelPeripheryReinfBeamDampCutoffHz = nil
        v.wheelPeripheryReinfBeamPrecompression = nil
        v.wheelPeripheryReinfBeamSpring = nil
        v.wheelReinfBeamDamp = nil
        v.wheelReinfBeamDampCutoffHz = nil
        v.wheelReinfBeamPrecompression = nil
        v.wheelReinfBeamSpring = nil
        v.wheelSideBeamDamp = nil
        v.wheelSideBeamDampExpansion = nil
        v.wheelSideBeamDeform = nil
        v.wheelSideBeamPrecompression = nil
        v.wheelSideBeamSpring = nil
        v.wheelSideBeamSpringExpansion = nil
        v.wheelSideBeamStrength = nil
        v.wheelSideTransitionZone = nil
        v.wheelTreadBeamDamp = nil
        v.wheelTreadBeamDampCutoffHz = nil
        v.wheelTreadBeamDeform = nil
        v.wheelTreadBeamPrecompression = nil
        v.wheelTreadBeamSpring = nil
        v.wheelTreadBeamStrength = nil
        v.wheelTreadReinfBeamDamp = nil
        v.wheelTreadReinfBeamDampCutoffHz = nil
        v.wheelTreadReinfBeamPrecompression = nil
        v.wheelTreadReinfBeamSpring = nil
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

    originalProcess(vehicle)  -- Call the original process, which now includes the modified processNodes
end

M.process = nodeBeam.process

return M
