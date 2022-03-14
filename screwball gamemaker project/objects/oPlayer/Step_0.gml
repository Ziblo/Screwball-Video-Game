/// @desc movement

//inputs
vinput=keyboard_check(ord("S"))-keyboard_check(ord("W")); //down is positive
hinput=keyboard_check(ord("D"))-keyboard_check(ord("A")); //right is positive
Einput=keyboard_check(ord("E"));

//process tools
if(holding_inst=noone && place_meeting(x+hsp,y+vsp,oTools_Parent) && no_regrab_timer==0){//if we're holding nothing and we collide with a tool
	//pick up tool
	holding_inst=instance_place(x+hsp,y+vsp,oTools_Parent)
	holding_inst.held=true;
}
if(holding_inst!=noone)
	holding_obj=object_get_name(holding_inst.object_index); //what are we actually holding? (for debugging)

//tool positioning
if(holding_inst!=noone && holding_inst.held){//if what I'm holding is being held...
	holding_inst.x=x+player_facing*3;
	holding_inst.y=y-14;
	holding_inst.hsp=hsp;
	holding_inst.vsp=vsp;
	holding_inst.image_xscale=player_facing;
	//drop tool
	if(Einput){
		holding_inst.held=false;
		holding_inst.hsp+=holding_inst.drop_hsp*player_facing;//drop with velocities (relative to player)
		holding_inst.vsp+=holding_inst.drop_vsp;
		no_regrab_timer=no_regrab_time; //start the countdown.
		holding_inst=noone;
	}
}
//no regrab
if(no_regrab_timer>0){//if timer is going
	no_regrab_timer--;//continue to count down.
}//otherwise the timer will rest at 0

//process physics/movement
player_physics([oCrate,oWall]);//ignore tools physics

//process player animations
player_animations();