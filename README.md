This mod attempts to optimize remote vehicles for better BeamMP performance. For the player vehicle it disables collision with itself.

Options are in lua/ge/extensions/perfMod.lua:

1. M.reduceCollision REMOTE VEHICLES: disables collision for nodes not on the outer shell. PLAYER VEHICLE: disables collision with own nodes
2. M.disablePropsLights REMOTE VEHICLES: disables headlight flares and all props except the wheel
3. M.disableAero REMOTE VEHICLES: sets all aerodynamic parameters to 0
4. M.disableTires REMOTE VEHICLES: removes tires and gives hubs tire-like properties
5. M.disableParticles = REMOTE VEHICLES: disables collision-based particle effects

Current bugs: 
1. Wheel nodes are very rarely left behind, creating a rather ugly looking stretching mesh. Probably fixable by editing the wheel jbeam parameters.
2. Player can't tow trailers because of reduced collisions. Could be fixed by excluding the critical nodes from the modifications.

Performance comparison with unmodded game running 20 AI-driven covets on the Automation Test Track:
![image](https://github.com/user-attachments/assets/94d24680-cb86-4e64-a4c9-7c21b78207a4)
