/// @desc toggle light if used and position beam

// Inherit the parent event
event_inherited();

if(used && !just_used){
	just_used=1;
	//switch toggle
	beam_toggle=!beam_toggle;
}
just_used=used;
//beam matches flashlight
flashlight_beam_inst.x=x//-hsp+3*tool_facing;
flashlight_beam_inst.y=y//-vsp;
flashlight_beam_inst.image_xscale=tool_facing;
