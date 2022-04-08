/// @description camera zoom and movement





// first match the image scale
view_height = image_yscale*pixel_size_y; //matches the view height to the camera object
view_width = image_xscale*pixel_size_x; //matches the view width to the camera object

if (view_height!=view_height_old || view_width!=view_width_old){
	//if view size has changed
	//surface_resize(application_surface, view_width, view_height);
	
}
#macro view view_camera[0]
camera_set_view_size(view, view_width, view_height);//set actual view size

var old_x = x //save these for parallax speed
var old_y = y


//to follow player while he's in room
if(instance_exists(oPlayer)){
	var _goal_x = oPlayer.x + 20*oPlayer.hsp - view_width/2;//goal is centered on the player +20hsp
	var _goal_y = oPlayer.y + 20*oPlayer.vsp - view_height/2;
	_goal_x += view_width/20*oPlayer.player_facing
	_goal_y-= view_height/6 - oPlayer.cork_shoot_falling*view_height/3;
	//accelerate to goal based on distance.
	var _distance_x = _goal_x-x;
	var _distance_y = _goal_y-y;
	hsp=_distance_x*acceleration;
	vsp=_distance_y*acceleration;
	x+=hsp;
	y+=vsp;
}
camera_set_view_pos(view, x, y);
view_height_old=view_height;
view_width_old=view_width;




//Parallax! x
var _x = old_x
var _b = ds_map_find_first(background_map);
repeat(ds_map_size(background_map)){ //Loop for every background_map starting with first
	layer_x(_b, background_map[? _b] * _x); //new x is layer *(1+speed)
	_b = ds_map_find_next(background_map, _b); //...then to the next
}
/*
//Parallax! y
var _y = old_y
var _b = ds_map_find_first(background_map);
repeat(ds_map_size(background_map)){ //Loop for every background_map starting with first
	layer_y(_b, background_map[? _b] * _y); //new x is layer *(1+speed)
	_b = ds_map_find_next(background_map, _b); //...then to the next
}
