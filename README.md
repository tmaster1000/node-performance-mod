This mod attempts to optimize remote vehicles for better BeamMP performance. For the player vehicle it disables collision with itself.

Options are in lua/ge/extensions/perfMod.lua:

M.reduceCollision = true -- REMOTE VEHICLES: disables collision for nodes not on the outer shell. PLAYER VEHICLE: disables collision with own nodes
M.disablePropsLights = true --REMOTE VEHICLES: disables headlight flares and all props except the wheel
M.disableAero = true --REMOTE VEHICLES: sets all aerodynamic parameters to 0
M.disableTires = true --REMOTE VEHICLES: removes tires and gives hubs tire-like properties
M.limitLua = false --REMOTE VEHICLES: limits controller update rate from 2000hz to 200hz or 1000hz
