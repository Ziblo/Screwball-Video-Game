/// @desc pause surface


if (paused){//paused
	if (!surface_exists(paused_surface)){
		//surface doesn't exist
		if (paused_surface!=-1){
			//surface was already initialized but isn't anymore
			instance_activate_layer("Instances");
			//redraw everything
			with(all){
				draw_self();
			}
			//reactivate so we can screenshot again.
		}
		//they either paused initially or minimized and reopened the window.
		
		//store a newly created surface's index to paused_surface
		paused_surface = surface_create(oCamera.view_width*oCamera.window_scale,oCamera.view_height*oCamera.window_scale); //oCamera.view_width*oCamera.window_scale, oCamera.view_height*oCamera.window_scale);
		surface_set_target(paused_surface);
		//draw target is now for paused_surface
			//for testing
			draw_rectangle_colour(-10, 10, oCamera.view_width*oCamera.window_scale+20, oCamera.view_height*oCamera.window_scale+20, c_green, c_green, c_green, c_green, false);
			//screenshot application surface by drawing it to paused_surface
			draw_surface(application_surface, 0, 0);//, 1/oCamera.window_scale, 1/oCamera.window_scale, 0, c_white, 1);
	    surface_reset_target();
		instance_deactivate_layer("Instances");
	}
	//paused surface DOES exist
	draw_surface_ext(paused_surface, oCamera.x, oCamera.y, 1/oCamera.window_scale, 1/oCamera.window_scale, 0, c_white, 1);
	draw_set_alpha(0.5);
	draw_rectangle_colour(oCamera.x, oCamera.y, oCamera.x + oCamera.view_width, oCamera.y + oCamera.view_height, c_black, c_black, c_black, c_black, false);
	draw_set_alpha(1);
	draw_set_halign(fa_center);
	draw_text_transformed_colour(oCamera.x + oCamera.view_width / 2, oCamera.y + oCamera.view_height / 2 - oCamera.image_yscale, "PAUSED", oCamera.image_xscale/10, oCamera.image_yscale/10, 0, c_aqua, c_aqua, c_aqua, c_aqua, 1);
	draw_text_transformed_colour(oCamera.x + oCamera.view_width / 2, oCamera.y + oCamera.view_height / 2 + oCamera.image_yscale, "Press spacebar anytime to reset level\nPress q to quit", oCamera.image_xscale/30, oCamera.image_yscale/20, 0, c_aqua, c_aqua, c_aqua, c_aqua, 1);
	draw_set_halign(fa_left);
}

