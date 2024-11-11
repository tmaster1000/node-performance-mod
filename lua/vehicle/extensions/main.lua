local main = require("vehicle/main")
extensions = require("extensions")
extensionsHook = extensions.hook
local frameCounter = 0
local updateEveryNFrames = 10

function onPhysicsStep(dtPhys)
    frameCounter = frameCounter + 1
    extensionsHook("onPhysicsStep", dtPhys)
    if frameCounter >= updateEveryNFrames then

        powertrain.update(dtPhys * updateEveryNFrames)  -- adjust time for skipped frames

        frameCounter = 0
    end
end

return main
