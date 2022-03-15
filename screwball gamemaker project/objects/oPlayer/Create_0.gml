/// @desc override defaults again

// Inherit the parent event
event_inherited();

//movement constants
ground_accel=.2;	//player ground acceleration
h_top_speed=50;		//player top speed
v_top_speed=50;
jump_speed=6;		//player initial jump speed

//physics constants
mass=12;
energy_loss=.5;		//percentage. 0 is super bouncy. 1 is sticky
frict=.2			//percentage. 0 is sandpaper.	 1 is slippery.
K_override=-1;		//-1 is no override (can override energy_loss)

collision_object_array=[oCrate,oWall,oShoe];//objects u can collide with (upon creation)

//player_direction
player_facing=1;//1 is right, -1 is left

//tools
holding_inst=noone;//instance_id of object in hand slot.
in_shoe=true
no_regrab_time=30;//amount of frames you can't regrab
no_regrab_timer=0;//initialize timer.
shoe_jump_cooldown=30;//amount of frames you can't collide w/ shoe
shoe_jump_cooldown_timer=-1;//initialize timer.

//player state
dead=false;