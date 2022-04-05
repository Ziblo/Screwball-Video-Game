/// @desc inherit defaults and override them

// Inherit the parent event
event_inherited();

//variables
hsp=0;			//horizontal speed
vsp=0;			//vertical speed

//constants
mass=5;		//mass. affects collisions.
energy_loss=.5;	//percentage. 0 is super bouncy. 1 is sticky
frict=.7;		//percentage. 0 is sandpaper.	 1 is slippery.
K_override=-1;	//override not active
collision_object_array=[oCrate,oWall,oTools_Parent,oShoe];//objects u can collide with

//tool variables
held=false;	//is being held by the player
drop_hsp=1;		//relative to player(facing) and relative to player hsp
drop_vsp=-3;	//relative to player vsp
tool_facing=1;	//1 is right, -1 is left
