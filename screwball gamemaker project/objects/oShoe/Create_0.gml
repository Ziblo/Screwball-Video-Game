/// @desc inherit player speed and stuff

event_inherited();

//physics constants
mass=12;
energy_loss=.5;		//percentage. 0 is super bouncy. 1 is sticky
frict=.2			//percentage. 0 is sandpaper.	 1 is slippery.
K_override=-1;		//-1 is no override (can override energy_loss)
//below variables are defined in cork_shoot() under Scripts/sActions
hsp=0;
vsp=0
shoe_facing=0;//1 is right, -1 is left
