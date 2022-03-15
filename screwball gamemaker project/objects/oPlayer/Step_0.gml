/// @desc movement

//inputs
vinput=keyboard_check(ord("S"))-keyboard_check(ord("W")); //down is positive
hinput=keyboard_check(ord("D"))-keyboard_check(ord("A")); //right is positive
drop_input=keyboard_check(ord("E"));

//process tools
if(can_hold_tool()){//if we're holding nothing and we collide with a tool
	//pick up tool
	holding_inst=instance_place(x+hsp,y+vsp,oTools_Parent)//save tool instance_id into holding_inst
}

//tool positioning
if(holding_inst!=noone){//if I'm holding something...
	holding_obj=object_get_name(holding_inst.object_index); //what is the name of the tool we're holding? (for debugging)
	position_tool();
}
//drop tool
if(drop_input){
	drop_tool();
}
//no regrab
if(no_regrab_timer>0){//if timer is going
	no_regrab_timer--;//continue to count down.
}//otherwise the timer will rest at 0

//process physics/movement
player_physics(collision_object_array);

//process player animations
player_animations();