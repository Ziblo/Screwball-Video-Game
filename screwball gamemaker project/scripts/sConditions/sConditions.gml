/*
	Function table of contents:
		can_hold_tool
*/
function can_hold_tool(){
	return (holding_inst=noone && place_meeting(x+hsp,y+vsp,oTools_Parent) && no_regrab_timer==0 && !dead);
}