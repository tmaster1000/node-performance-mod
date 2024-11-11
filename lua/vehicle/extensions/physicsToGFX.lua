local M = {}

local function updateGFX(dtSim)
    wheels.updateWheelVelocities(dtSim)
    wheels.updateWheelTorques(dtSim)
    thrusters.update()
    hydros.update(dtSim)
end

M.updateGFX = updateGFX
return M