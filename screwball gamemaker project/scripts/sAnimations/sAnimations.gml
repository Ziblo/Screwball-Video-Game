/*
	Function table of contents:
		player_animations
		
		draw_tool
		draw_shoe
*/

function player_animations(){
///@funct			player_animations()
///@desc			Process player sprites and animations.
	//Facing
	if(dead){
		//death animation
		play_animation_stop(sPlayer_death,.2);
	}
	else{//if we're not dead
		
		//calculate player facing
		if(abs(hinput)){
			player_facing=hinput;
		}
		image_xscale=player_facing*abs(image_xscale);//apply player_facing
		
		//specific animations
		if(cork_shoot_falling==1){
			play_animation_repeat(sPlayer_spin)
		}
		else if(cork_shoot_falling==2){
			if (cork_shoot_bounce){
				sprite_index=sPlayer_death;
				image_index=1;
			}
			else play_animation_repeat(sPlayer_spin,5)//faster!
		}
		//otherwise default
		else sprite_index=sPlayer;
	}
}

//DRAW FUNCTIONS
function draw_tool(_holding_inst=holding_inst){
	//draw tool
	with(oPlayer){
		if(_holding_inst!=noone){
			draw_sprite_ext(_holding_inst.sprite_index,1,x+3*player_facing,y-14,player_facing,1,0,c_white,1);
		}
	}
}
function draw_shoe(){
	//draw shoe
	if(in_shoe){
		draw_sprite_ext(sShoe,1,x,y,player_facing,1,0,c_white,1);
	}
}