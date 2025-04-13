-- This Source Code Form is subject to the terms of the bCDDL, v. 1.1.
-- If a copy of the bCDDL was not distributed with this
-- file, You can obtain one at http://beamng.com/bCDDL-1.1.txt

local M = {}
local depthCoef = 0.5 / physicsDt

local materials, materialsMap = particles.getMaterialsParticlesTable()

M.particleData = {
  id1 = 0,
  pos = 0,
  normal = 0,
  nodeVel = 0,
  perpendicularVel = 0,
  slipVec = 0,
  slipVel = 0,
  slipForce = 0,
  normalForce = 0,
  depth = 0,
  materialID1 = 0,
  materialID2 = 0
}

-- Flag to control execution of nodeCollision function.
local skipNodeCollision = false

-- Setter function to change the flag.
local function setSkipNodeCollision(flag)
    print(flag)
  skipNodeCollision = flag
end

local function nodeCollision(p)
  if skipNodeCollision then
    return
  end

  if p.perpendicularVel > p.depth * depthCoef then
    local pKey = p.materialID1 * 10000 + p.materialID2
    local mmap = materialsMap[pKey]
    if mmap ~= nil then
      for _, r in pairs(mmap) do
        if r.compareFunc(p) then
          obj:addParticleVelWidthTypeCount(p.id1, p.normal, p.nodeVel, r.veloMult, r.width, r.particleType, r.count)
        end
      end
    end
  end
end

-- public interface
M.nodeCollision = nodeCollision
M.setSkipNodeCollision = setSkipNodeCollision
return M
