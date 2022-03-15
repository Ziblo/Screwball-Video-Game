/// @desc inherit player speed and stuff

// Inherit the parent event
event_inherited();

//physics constants
mass=12;
energy_loss=.5;		//percentage. 0 is super bouncy. 1 is sticky
frict=.2			//percentage. 0 is sandpaper.	 1 is slippery.
K_override=-1;		//-1 is no override (can override energy_loss)

//player_direction
player_facing=oPlayer.player_facing;//1 is right, -1 is left

//tools
in_shoe=false
hsp=oPlayer.hsp;
vsp=oPlayer.vsp;

image_xscale=oPlayer.player_facing;