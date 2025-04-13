--Credit: tmaster1000(GitHub) / thrustermaster (Discord)
--Injects into nodeBeam.lua to alter wheel generation. Done here instead of wheels.lua for convenience.
local M = {}
local logtag = "nodePerformanceMod.nodeBeam"
local nodeBeam = require("common/jbeam/sections/nodeBeam")

local originalProcess = nodeBeam.process

local function simplifyWheels(vehicle)
    if vehicle["pressureWheels"] ~= nil then
        for k, v in pairs(vehicle["pressureWheels"]) do
            --v.hasTire = true we fake a tire for later logic
            --v.brakeType = "vented-disc"
            v.collision = true
            v.disableHubMeshBreaking = false
            v.disableMeshBreaking = false
            --v.enableBrakeThermals = false
            v.enableTireLbeams = false
            v.enableTirePeripheryReinfBeams = false
            v.enableTireReinfBeams = false
            v.enableTireSideReinfBeams = false
            v.enableTreadReinfBeams = false

            v.hubBeamDeform = 75568.34375
            v.hubBeamStrength = 85626
            if v.frictionCoef ~= nil then
                v.hubFrictionCoef = v.frictionCoef * 1.2
            end
            v.hubNodeMaterial = 4
            v.hubNodeWeight = 0.65
            v.hubPeripheryBeamDamp = 250
            v.hubPeripheryBeamSpring = 401000
            if v.frictionCoef ~= nil then
                v.hubRadiusSimple = v.hubRadius
            end
            if v.radius ~= nil then
                v.hubRadius = v.radius
            end
            v.hubReinfBeamDamp = 600
            v.hubReinfBeamSpring = 651000
            v.hubSideBeamDamp = 300
            v.hubSideBeamSpring = 421000
            if v.wheelTreadBeamDamp ~= nil then
                v.hubTreadBeamDamp = v.wheelTreadBeamDamp
            end

            if v.wheelTreadBeamSpring ~= nil then
                v.hubTreadBeamSpring = v.wheelTreadBeamSpring
            end

            if v.tireWidth ~= nil then
                v.hubWidth = v.tireWidth
            end

            v.nodeS = 9999

            v.numRays = math.floor(v.numRays / 1.6 + 0.5)
            if v.numRays % 2 ~= 0 then
                v.numRays = v.numRays + 1
            end
            v.optional = true
            --v.padMaterial = "sport"
            --v.rotorMaterial = "steel"
            --v.scaledragCoef = 2.15
            --v.scalenodeWeight = 1.2
            v.selfCollision = false
            --v.softnessCoef = 0.7
            --v.treadCoef = 0.7
            v.triangleCollision = false

            v.breakGroup = nil
            v.deformGroup = nil
            v.dragCoef = nil
            v.enableABS = false
            v.enableHubcaps = false
            v.frictionCoef = nil
            v.fullLoadCoef = nil
            v.loadSensitivitySlope = nil
            v.noLoadCoef = nil
            v.nodeMaterial = nil
            v.nodeWeight = nil
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
        log("I", logtag, "vehicle[pressureWheels] is nil")
    end

    -- for k in pairs(vehicle["beams"]) do
    --   if vehicle["beams"][k].beamType == 2 then
    --   vehicle["beams"][k].beamType = 0
    ---   end
    -- end
end
local function limitNumrays(vehicle)
    if vehicle["pressureWheels"] ~= nil then
    for k, v in pairs(vehicle["pressureWheels"]) do
        if v.numRays > 10 then
            local half = math.floor(v.numRays / 2)
            if half < 10 then
                half = 10
            end
            v.numRays = half
        end
    end
    else
        log("I", logtag, "vehicle[pressureWheels] is nil")
    end
end


nodeBeam.process = function(vehicle)
    if nodePerformanceMod.disableTires and not nodePerformanceMod.playerSpawnProcessing and not nodePerformanceMod.playerReloadProcessing then
        simplifyWheels(vehicle)
        log("I", logtag, "Simplified Wheels for remote vehicle")
    end

    if nodePerformanceMod.limitNumrays and not nodePerformanceMod.disableTires and not nodePerformanceMod.playerSpawnProcessing and not nodePerformanceMod.playerReloadProcessing then
        limitNumrays(vehicle)
        log("I", logtag, "Limited rays for remote vehicle")
    end

    originalProcess(vehicle)
end

M.process = nodeBeam.process

return M
