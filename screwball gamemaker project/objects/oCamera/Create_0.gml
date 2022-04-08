/// @description window size


pixel_size_y=9;
pixel_size_x=16;
if(image_xscale != image_yscale){
	show_error("Aspect ratio not valid. Try checking oCamera scale",false);
}
view_height = image_yscale*pixel_size_y; //matches the view height to the camera object
view_width = image_xscale*pixel_size_x; //matches the view width to the camera object
view_height_old=view_height;
view_width_old=view_width;
//Window Scale is first defined in the object variables
//how big the window is on your computer screen
//min so it will fit on your screen if the aspect ratio doesn't match your screen
//120 = 1920/16 = 1080/9
window_scale *= min(120/image_yscale,120/image_xscale);
window_set_size(view_width*window_scale, view_height*window_scale);
surface_resize(application_surface, view_width, view_height);
alarm[0]=1; //have to call window_center() one step later *shrug*

image_alpha=0;

hsp=0; //camera speed
vsp=0;
acceleration=1/20;



//Parallax

background_map = ds_map_create(); //Creating a "ds" map that associates the values with the layer
background_map[? layer_get_id("Distant_Mountains")] = 0.7; //the further away, the bigger the number
background_map[? layer_get_id("Close_Mountains")] = .5; //a layer between cam and plaer would have a negative value