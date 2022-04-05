/// @desc initialize variables & constants.

//variables
hsp=0;			//horizontal speed
vsp=0;			//vertical speed

//constants
mass=99999;		//mass. affects collisions.
energy_loss=.5;	//percentage. 0 is super bouncy. 1 is sticky
frict=.5;		//percentage. 0 is sandpaper.	 1 is slippery.
K_override=-1; //-1 is no override