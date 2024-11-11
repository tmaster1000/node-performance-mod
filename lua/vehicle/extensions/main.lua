local main = require("vehicle/main")
extensions = require("extensions")
extensionsHook = extensions.hook
local frameCounter = 0
local updateEveryNFrames = 10

function onPhysicsStep(dtPhys)
    frameCounter = frameCounter + 1

    if frameCounter >= updateEveryNFrames then
        extensionsHook("onPhysicsStep", dtPhys)
        powertrain.update(dtPhys * updateEveryNFrames)  -- adjust time for skipped frames

        frameCounter = 0
    end
end

return main
