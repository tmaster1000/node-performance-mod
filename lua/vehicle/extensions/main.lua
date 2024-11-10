local main = require("vehicle/main")
extensions = require("extensions")
extensionsHook = extensions.hook

function onPhysicsStep(dtPhys)
    powertrain.update(dtPhys)
    controller.updateWheelsIntermediate(dtPhys)
    extensionsHook("onPhysicsStep", dtPhys)
end

M.updateGFX = updateGFX
return main