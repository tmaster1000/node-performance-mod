**This mod attempts to optimize remote vehicles for better BeamMP performance. For the player vehicle it disables collision with itself.
**

Options are in lua/ge/extensions/perfMod.lua:

1. M.reduceCollision = true -- REMOTE VEHICLES: disables collision for nodes not on the outer shell. PLAYER VEHICLE: disables collision with own nodes
2. M.disablePropsLights = true --REMOTE VEHICLES: disables headlight flares and all props except the wheel
3. M.disableAero = true --REMOTE VEHICLES: sets all aerodynamic parameters to 0
4. M.disableTires = true --REMOTE VEHICLES: removes tires and gives hubs tire-like properties
5. M.limitLua = false --REMOTE VEHICLES: limits controller update rate from 2000hz to 200hz or 1000hz

Current bugs: 
1. Wheel nodes are very rarely left behind, creating a rather ugly looking stretching mesh. Probably fixable by editing the wheel jbeam parameters.
2. Player can't tow trailers because of reduced collisions. Could be fixed by excluding the critical nodes from the modifications.
