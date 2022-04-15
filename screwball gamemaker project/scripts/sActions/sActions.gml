/*
	Function table of contents:
		drop_tool
		position_tool
		player_death
		play_animation_stop
		play_animation_repeat
		cork_shoot
*/
function drop_tool(){
//drop the tool
//is run from the player object
	if(holding_inst!=noone){
		with(holding_inst){ //this basically runs the code below from the holding_inst instead of the player
			//place instance at its last valid position
			x=x_valid;
			y=y_valid;
			//give it a hsp and vsp
			hsp+=drop_hsp*oPlayer.player_facing;//drop with velocities (relative to player)
			vsp+=drop_vsp;
		}
		//start the no_regrab countdown.
		no_regrab_timer=no_regrab_time;
		//clear holding slot
		holding_inst=noone;
	}
}
function use_tool(){
	
}
function position_tool(){
//keep the tool in the players hand and save most recent valid position
	//save valid position
	if(!place_meeting_or(x,y,collision_object_array)){
		x_valid = x;
		y_valid = y;
	}
	//give it player hsp
	hsp=oPlayer.hsp;
	vsp=oPlayer.vsp;
	//give it player position
	x=oPlayer.x+oPlayer.player_facing*3	+hsp;//approximation position (we're gonna draw it more exact in draw_tool)
	y=oPlayer.y-14						+vsp;//approximating position
	tool_facing=oPlayer.player_facing;
	
}
function player_death(){
///@funct			player_death
///@desc			execute player death sequence
	dead=true;
	cork_shoot_falling=0;
	image_index=0;
	K_override=.8;//no bounce
	audio_play_sound(souDeath,1,false);
	drop_tool();
}
function play_animation_stop(spr_indx,_speed=1){
//plays an animation until last frame
	sprite_index=spr_indx;
	var _total_frames = sprite_get_number(spr_indx)-1;
	image_index=min(image_index+_speed, _total_frames);
	return;
}
function play_animation_repeat(spr_indx,_speed=1){
//plays an animation and repeats it
	sprite_index=spr_indx;
	var number_of_frames=(sprite_get_number(spr_indx)-1)
	image_index=(image_index+1*_speed)%number_of_frames;
}
function cork_shoot(){
	if(in_shoe){//player can only corkshoot if they're in the shoe
		in_shoe=false;//not in shoe anymore
		cork_shoot_cooldown_timer=cork_shoot_cooldown;//start cooldown timer
		collision_object_array=array_remove_values(collision_object_array,[oShoe]);//remove shoe from collision array. (when in cooldown, you can't collide with shoe again)
		var _shoe_instance_id = instance_create_layer(x,y,"Solids",oShoe);
		_shoe_instance_id.tool_facing=oPlayer.player_facing;
		collision_cork_shoot(_shoe_instance_id);//takes care of player jump vsp and shoe vsp and hsp
		audio_play_sound(souCork_Shoot,1,false);
	}
}