/// @description window size
// You can write your code in this editor
view_height = 1080/6;
view_width = 1920/6;
window_scale = 6;

window_set_size(view_width*window_scale, view_height*window_scale);
alarm[0]=1; //have to call window_center() one step later *shrug*
surface_resize(application_surface, view_width*window_scale, view_height*window_scale)

image_alpha=0;

hsp=0; //camera speed
vsp=0;
acceleration=1/20;



//Parallax

background_map = ds_map_create(); //Creating a "ds" map that associates the values with the layer
background_map[? layer_get_id("Distant_Mountains")] = 0.7; //the further away, the bigger the number
background_map[? layer_get_id("Close_Mountains")] = .5; //a layer between cam and plaer would have a negative value