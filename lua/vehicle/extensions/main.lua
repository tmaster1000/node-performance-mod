local main = require("vehicle/main")
extensions = require("extensions")
extensionsHook = extensions.hook
local frameCounter = 9 -- initialize at 9 so the first physics step is 2000hz
local updateEveryNFrames = 10

function onPhysicsStep(dtPhys)
    frameCounter = frameCounter + 1
    extensionsHook("onPhysicsStep", dtPhys) --beammp itself runs on physics step, dont wanna touch this

    if frameCounter >= updateEveryNFrames then
        wheels.updateWheelVelocities(dtPhys * updateEveryNFrames)
        powertrain.update(dtPhys * updateEveryNFrames)
        controller.updateWheelsIntermediate(dtPhys * updateEveryNFrames)
        wheels.updateWheelTorques(dtPhys * updateEveryNFrames)
        controller.update(dtPhys * updateEveryNFrames)
        thrusters.update()
        hydros.update(dtPhys * updateEveryNFrames)
        beamstate.update(dtPhys * updateEveryNFrames)
        protocols.update(dtPhys * updateEveryNFrames)
        frameCounter = 0
    end
end

return main
