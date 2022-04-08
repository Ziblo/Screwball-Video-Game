/// @desc movement

//GETTING PLAYER INPUTS
vinput=keyboard_check(ord("S"))-keyboard_check(ord("W")); //down is positive
hinput=keyboard_check(ord("D"))-keyboard_check(ord("A")); //right is positive
drop_input=keyboard_check(ord("Q"));
use_input=keyboard_check(ord("E"));

//detemine some conditions
can_hold_tool = (
				holding_inst=noone && 
				place_meeting(x+hsp,y+vsp,oTools_Parent) &&	
				no_regrab_timer==0 && 
				!dead
				);
on_ground =	place_meeting_or(x,y+3,collision_object_array);
apply_gravity = ( 
				!place_meeting_or(x,y+global.grav_accel,collision_object_array) &&
				!cork_shoot_falling
				);

//process player inputs into movement
if(!dead){
	hsp=clamp(hsp+hinput*ground_accel,-h_top_speed,h_top_speed); //can accelerate to top speed
	vsp=clamp(vsp,-v_top_speed,v_top_speed);	//vsp within terminal velocity of v_top_speed
	//cork_shoot
	if(in_shoe && vinput==-1){//up inuput
		cork_shoot();
	}
	if(cork_shoot_falling==1){
		//air friction
	}
	if(cork_shoot_falling && vinput==1){//down input while cork_shoot_falling
		cork_shoot_falling=2;//fast fall
	}
}
else{
	cork_shoot_falling=2;
}

//process tools
if(drop_input){
	//drop tool
	drop_tool();
}
if(use_input){
	//use tool
	use_tool();
}
if(can_hold_tool){//if we're holding nothing and we collide with a tool
	//pick up tool
	holding_inst=instance_place(x+hsp,y+vsp,oTools_Parent)//save tool instance_id into holding_inst
	
}
//tool name (for debugging)
if(holding_inst!=noone){//if I'm holding something...
	holding_obj=object_get_name(holding_inst.object_index); //what is the name of the tool we're holding? (for debugging)
}
//no regrab
if(no_regrab_timer>0){//if timer is going
	no_regrab_timer--;//continue to count down.
}//otherwise the timer will rest at 0

//process physics/movement
player_physics(collision_object_array);

//process player animations
player_animations();