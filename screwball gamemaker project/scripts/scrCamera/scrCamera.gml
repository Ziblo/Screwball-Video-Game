


function update_screen_mode(){
	//apply screen mode
	switch (screen_mode) {
	    case 0:			//Windowed//
			window_set_fullscreen(false);
	        window_set_size(game_resolution_x, game_resolution_y);
			alarm[0]=1;	//alarm to call window_center() next step
	        break;
		case 1:			//Fullscreen//
	        window_set_fullscreen(true);
	        break;
		case 2:			//Fullscreen-Windowed(scaled up)//
			window_set_fullscreen(false);
			//set window size to the display size of the device
			window_set_size(display_get_width(), display_get_height());
			alarm[0]=1;	//alarm to call window_center() next step
	        break;
	    default: //Shouldn't be possible. Error.
	        show_error("Invalid screen_mode. screen_mode must be 0, 1, or 2 (windowed, fullscreen, fullscreen_windowed",true);
	}
}