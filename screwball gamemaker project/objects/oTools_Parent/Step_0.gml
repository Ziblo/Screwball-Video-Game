/// @desc [insert description here]

//check if we're being held
if(instance_exists(oPlayer)){
	held=(oPlayer.holding_inst==id);
}
else{
	held=false
}

//check if we're being "used"
used=(held && oPlayer.use_input);

if(held){
	position_tool()//stay in player's hand
		
	///////////////////////
	//do some tooly thing//
	///////////////////////
	
}
else{
	physics(collision_object_array);
}

//facing
image_xscale=tool_facing;

