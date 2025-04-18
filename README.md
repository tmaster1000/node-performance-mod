This mod attempts to optimize remote vehicles for better BeamMP performance. For the player vehicle it disables collision with itself.

**Important, read before using:**
For BeamMP to work the best, the remote vehicle needs to be as similar as possible both in your game as in the game of the person driving it.
This means that the wheel and aero modifications of this mod unfortunately can cause desync.
Collision editing only causes desync in the event of someone crashing their vehicle, but the difference this makes for sync is negligible.

**All the modifications only affect remove vehicles except reduceCollisions, which stops player vehicle colliding with itself. For remote vehicles it does heavier modifications**

Options are in lua/ge/extensions/nodePerformanceMod.lua:

Safe to use:
1. M.reduceCollision = true -> Disables all collision for nodes not on the outer shell and self-collision for all nodes. Also disables player vehicle collision with own nodes.
2. M.disablePropsLights = true -> Disables headlight flares and all props except the wheel. Note: doesn't disable headlight glow and some lights that are implemented differently. Highly recommended to leave this enabled.
3. M.disableParticles = true -> Disables collision-based particle effects. Does not disable all particle effects
4. M.disableMapLights = true -> Disables map lights
Experimental, might cause desync
1. M.disableTires = false -> Removes tires and gives hubs tire-like properties
2. M.disableAero = false -> sets all aerodynamic parameters to 0
3. M.limitWheelComplexity = false -> limits wheel numray count but doesnt disable tires

Current bugs: 
1. Player can't tow trailers because of reduced collisions. Could be fixed by excluding the critical nodes from the modifications.
2. **Incompatibility with the following mods**:
   1. Scintilla GT3. Fixed on rigged servers but elsewhere this car is incompatible with disableTires because it doesn't check if tires exist before extracting properties from them.
-> set disableTires to false to fix this.

Performance comparison with unmodded game running 20 AI-driven covets on the Automation Test Track with 'High' graphics preset. (**note, this was done with all options enabled**)
![image](https://github.com/user-attachments/assets/94d24680-cb86-4e64-a4c9-7c21b78207a4)

THIS MOD AND CODE IS PROTECTED BY THE GNU AFFERO GENERAL PUBLIC LICENSE v3.0 (AGPL). Distributing closed‑source versions is strictly prohibited.
