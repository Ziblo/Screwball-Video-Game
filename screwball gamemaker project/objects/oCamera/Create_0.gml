/// @description window size


//get camera view size directly from the existing instance of oCamera
if (image_xscale != image_yscale){
	show_error("Aspect ratio not valid. Try checking oCamera image_scale(s)",false);
}
//how many in-game pixels are displayed in the window
view_width = sprite_width;		//matches the view width to the camera object
view_height = sprite_height;	//matches the view height to the camera object
view_height_old = view_height;
view_width_old = view_width;

//set initial window size by updating screen mode
update_screen_mode();			//(function defined in scrCamera)

//This is the resolution of the game
surface_resize(application_surface, game_resolution_x, game_resolution_y);

image_alpha=0; //make camera object invisible

hsp=0; //camera horizontal speed		units per frame
vsp=0; //camera vertical speed
frequency=1/20; //frequency of travel	1/frame
//so that the camera will travel 1/20 units/frame for every unit distance it is from camera's goal
//if the camera is only 20 units away from its goal, it will travel at 1 unit/frame


//Parallax
background_distance_M = ds_map_create(); //Creating a "ds" map that associates the values with the layer
background_distance_M[? layer_get_id("Distant_Mountains")] = 0.7; //the further away, the bigger the number
background_distance_M[? layer_get_id("Close_Mountains")] = .5; //a layer between cam and plaer would have a negative value
background_distance_M[? layer_get_id("Horizon")] = 1;
