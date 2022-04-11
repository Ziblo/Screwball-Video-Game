/// @desc player constants

//movement constants
ground_accel=.2;	//player ground acceleration
h_top_speed=50;		//player top speed
v_top_speed=50;
jump_speed=6;		//player initial jump speed
cork_shoot_falling=0;	//corkshoot flag. 0 1 2 for fall speed
cork_shoot_fall_vsp=.1;	//corkshoot falling speed

//physics constants & variables (from oSolid)
mass=12;
energy_loss=.5;		//percentage. 0 is super bouncy. 1 is sticky
ground_frict=.2		//acceleration
air_frict=.1		//acceleration to 0 when not inputing and cork_shoot_falling
K_override=-1;		//-1 is no override (can override energy_loss)
hsp=0;
vsp=0;
collision_object_array=[oCrate,oWall];//objects u can collide with (upon creation)

//player state constants & variables
dead=false;
player_facing=1;//1 is right, -1 is left

//tools
holding_inst=noone;//instance_id of object in hand slot.
no_regrab_time=30;//amount of frames you can't regrab

//shoe
in_shoe=true;
cork_shoot_cooldown=4;//amount of frames you can't collide w/ shoe

//INITIALIZE TIMERS
cork_shoot_cooldown_timer=-1;//initialize timer.
no_regrab_timer=0;//initialize timer.
