/// @desc pause, zoom, or reset
//check for inputs
reset_input=keyboard_check(vk_space);
pause_input=keyboard_check(vk_escape);
zoom_input=keyboard_check(vk_up)-keyboard_check(vk_down);

//PAUSE
if(pause_input&&!old_pause_input){//key initial press
	//toggle pause game
	paused = !paused;
	if (!paused){
		instance_activate_layer("Instances");
		surface_free(paused_surface);
		paused_surface = -1;
	}
	else{//(paused)
		//deactivalte instances in the "Instances" layer
		//This includes everything that moves when the game moves
	}
	
}
old_pause_input=pause_input;

//RESET
if(paused&&reset_input){
	//reset level (FOR DEBUGGING)
	room_restart();
}

//ZOOM
if(abs(zoom_input)){
	with(oCamera){
		var _zoom = oGame.zoom_input;
		var _center_x = image_xscale*16/2 // view_width/2
		var _center_y = image_yscale*9/2 // view_height/2
		/*
		new_center = (imagescale+zoom)*16/2
		new_width = (imagescale+zoom)*16
		_x+ = old_center-new_center
		*/
		image_xscale = max(image_xscale - _zoom,1);
		image_yscale = max(image_yscale - _zoom,1);
		var _new_center_x = image_xscale*16/2 // view_width/2
		var _new_center_y = image_yscale*9/2 // view_height/2
		x += _center_x-_new_center_x;
		y += _center_y-_new_center_y;
	}
	
}
