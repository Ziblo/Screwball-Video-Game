/// @desc Basic tool functionality

//check if we're being held
if(instance_exists(oPlayer)){
	//Condition: Are we being held?
	held=(oPlayer.holding_inst==id);
}
else{
	held=false
}

//condition: check if we're being "used"
used = (held && oPlayer.use_input);
if(held){
	position_tool()//stay in player's hand
}
else{
	physics(collision_object_array);
}

//facing
image_xscale=tool_facing;

