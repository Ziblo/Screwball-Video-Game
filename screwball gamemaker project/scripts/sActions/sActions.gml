/*
	Function table of contents:
		drop_tool
		position_tool
		player_death
		play_animation_stop
*/
function drop_tool(){
//	holding_inst.held=false; //set tool to not being held
	if(holding_inst!=noone){
		holding_inst.hsp+=holding_inst.drop_hsp*player_facing;//drop with velocities (relative to player)
		holding_inst.vsp+=holding_inst.drop_vsp;
		no_regrab_timer=no_regrab_time; //start the no_regrab countdown.
		holding_inst=noone;
	}
}
function position_tool(){
	holding_inst.x=x+player_facing*3;
	holding_inst.y=y-14;
	holding_inst.hsp=hsp;
	holding_inst.vsp=vsp;
	holding_inst.image_xscale=player_facing;
}
function player_death(){
///@funct			player_death
///@desc			execute player death sequence
	dead=true;
	image_index=0;
	K_override=1;//no bounce
	drop_tool();
}
function play_animation_stop(spr_indx,_speed=1){
//plays an animation until last frame
	sprite_index=spr_indx;
	image_index=min(image_index+1*_speed,sprite_get_number(spr_indx)-1);
}
function shoe_jump(){
	vsp=-jump_speed;
	in_shoe=false;
	instance_create_layer(x,y,"Instances",oShoe);
	collision_object_array=array_remove_values(collision_object_array,[oShoe]);
}