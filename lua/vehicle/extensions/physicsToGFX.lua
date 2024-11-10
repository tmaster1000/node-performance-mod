local M = {}

local function updateGFX(dtSim)
    hydros.update(dtSim)
    wheels.updateWheelVelocities(dtSim)
    wheels.updateWheelTorques(dtSim)
    thrusters.update()
    beamstate.update(dtSim)
    protocols.update(dtSim)
end


M.updateGFX = updateGFX
return M