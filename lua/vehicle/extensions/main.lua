local main = require("vehicle/main")
extensions = require("extensions")
extensionsHook = extensions.hook
local frameCounter10 = 9
local frameCounter2 = 1
local updateEvery10Frames = 10
local updateEvery2Frames = 2

function onPhysicsStep(dtPhys)
    powertrain.update(dtPhys) --stops vehicle instability
    extensionsHook("onPhysicsStep", dtPhys) --keeps beammp in sync

    frameCounter10 = frameCounter10 + 1
    frameCounter2 = frameCounter2 + 1

    if frameCounter2 >= updateEvery2Frames then -- updated at 1000hz to stop vehicle instability
        wheels.updateWheelTorques(dtPhys * updateEvery2Frames)
        wheels.updateWheelVelocities(dtPhys * updateEvery10Frames)
        controller.updateWheelsIntermediate(dtPhys * updateEvery10Frames)
        thrusters.update()
        frameCounter2 = 0
    end

    if frameCounter10 >= updateEvery10Frames then --updated at 200hz
        controller.update(dtPhys * updateEvery10Frames)
        hydros.update(dtPhys * updateEvery10Frames)
        beamstate.update(dtPhys * updateEvery10Frames)
        protocols.update(dtPhys * updateEvery10Frames)
        frameCounter10 = 0
    end
end

return main
