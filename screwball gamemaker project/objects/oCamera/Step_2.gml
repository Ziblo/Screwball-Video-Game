/// @description camera zoom and movement

// first update view_width to match sprite_width of the oCamera instance
view_width = sprite_width;		//matches the view width to the camera object
view_height = sprite_height;	//matches the view height to the camera object


if (view_height!=view_height_old || view_width!=view_width_old){
	//if view size has changed
}
view_height_old=view_height;
view_width_old=view_width;

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
	//This is prettymuch a velocity vector field where vv = dd*f
	//velocity vector is proportional to the distance vecctor
	hsp=_distance_x*frequency;
	vsp=_distance_y*frequency;
	x+=hsp;
	y+=vsp;
}
camera_set_view_pos(view, x, y); //camera view stays with camera object



		//PARALLAX//
//Functionally our index. (stores the layer_id)
var _layer = ds_map_find_first(background_distance_M);
//Loop for every background_map starting with first
repeat(ds_map_size(background_distance_M)){
	//temporarily save current position of layer
	var _Ly = layer_get_y(_layer);
	var _Lx = layer_get_x(_layer);
	//shift the layer_x to move proportionally to oCamera.hsp
	layer_x(_layer, _Lx + background_distance_M[? _layer] * hsp);
	//shift the layer_y to move proportionally to oCamera.vsp
	layer_y(_layer, _Ly + background_distance_M[? _layer] * vsp);
	
	//move on to next layer_id within the ds_map. Sort of like _b++;
	_layer = ds_map_find_next(background_distance_M, _layer);
}
