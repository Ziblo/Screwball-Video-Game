/// @desc describe end_action

//end_action:
/*
	Constant				Description
path_action_stop		Stop the path
path_action_restart		Continue from start position, jumping to the start if the path is not closed
path_action_continue	Start the path again from the current position
path_action_reverse		Reverse the speed of the path (run the path in reverse)
*/

//follow path
if (path == noone) show_error("Path not specified", true);
else {
	path_start(path,path_speed,end_action,absolute);
	//length = path_get_length(path); //length of path in pixels
	//path_position = 0;
	x_old = x;
	y_old = y;
}
