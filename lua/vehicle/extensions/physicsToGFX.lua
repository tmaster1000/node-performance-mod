local M = {}

local function updateGFX(dtSim)
    wheels.updateWheelVelocities(dtSim)
    wheels.updateWheelTorques(dtSim)
    thrusters.update()
    hydros.update(dtSim)
    controller.update(dtPhys)
end

M.updateGFX = updateGFX
return M