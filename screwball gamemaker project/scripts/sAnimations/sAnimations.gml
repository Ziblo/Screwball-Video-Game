/*
	Function table of contents:
		player_animations
*/

function player_animations(){
///@funct			player_animations()
///@desc			Process player sprites and animations.
	
	if(abs(hinput)){
		player_facing=hinput;
	}
	image_xscale=player_facing*abs(image_xscale);	
}

//DRAW FUNCTIONS
function draw_tool(){
	//draw tool
	if(holding!=noone){
		draw_sprite_ext(object_get_sprite(holding),1,x,y,player_facing,1,0,c_white,1);
	}
}
function draw_shoe(){
	//draw shoe
	if(in_shoe){
		draw_sprite_ext(sShoe,1,x,y,player_facing,1,0,c_white,1);
	}
}