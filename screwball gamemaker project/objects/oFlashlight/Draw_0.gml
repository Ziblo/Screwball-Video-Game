/// @desc draw da light
//(tool when held is drawn in the player object)
if(!held){	draw_self();
}
if(held && beam_toggle){
	draw_tool(flashlight_beam_inst);
}
else if(beam_toggle){
	with(flashlight_beam_inst){
		draw_self();
	}
}
