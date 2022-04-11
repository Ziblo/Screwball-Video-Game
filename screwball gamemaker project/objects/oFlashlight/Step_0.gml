/// @desc toggle light if used and position beam

// Inherit basic tool functionality
event_inherited();

if(used && !old_used){
	//switch toggle
	beam_toggle=!beam_toggle;
}

//beam matches flashlight
flashlight_beam_inst.x=x//-hsp+3*tool_facing;
flashlight_beam_inst.y=y//-vsp;
flashlight_beam_inst.image_xscale=tool_facing;
