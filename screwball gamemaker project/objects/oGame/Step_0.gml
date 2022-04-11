/// @desc pause, zoom, or reset
//check for inputs

if (oCrate.db_col_occ){
	var _bruh=1;
}

reset_input=keyboard_check(vk_space);
pause_input=keyboard_check(vk_escape);
zoom_input=keyboard_check(vk_up)-keyboard_check(vk_down);
quit_input=keyboard_check(ord("Q"));
fullscreen_input=keyboard_check(vk_f11);

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
		//instance_deactivate_layer("Instances");
		//This includes everything that moves when the game moves
	}

}
old_pause_input=pause_input;

//RESET
if(reset_input){
	//reset level (FOR DEBUGGING)
	room_restart();
}

//ZOOM
if(abs(zoom_input)){
	with(oCamera){
		var _zoom = oGame.zoom_input;
		var _center_x = sprite_width/2 // view_width/2
		var _center_y = sprite_height/2 // view_height/2
		/*
		new_center = (imagescale+zoom)*16/2
		new_width = (imagescale+zoom)*16
		_x+ = old_center-new_center
		*/
		image_xscale = max(image_xscale - _zoom,1);
		image_yscale = max(image_yscale - _zoom,1);
		var _new_center_x = sprite_width/2 // view_width/2
		var _new_center_y = sprite_height/2 // view_height/2
		x += _center_x-_new_center_x;
		y += _center_y-_new_center_y;
	}
	
}

//Quit
if (paused && quit_input){
	game_end();
}

if (fullscreen_input && !old_fullscreen_input){	//initial press
	//toggle screen_mode
	oCamera.screen_mode = (oCamera.screen_mode + 1)%2;	//only toggle between fullscreen and windowed
	with(oCamera){
		update_screen_mode();
	}
}
old_fullscreen_input=fullscreen_input;
