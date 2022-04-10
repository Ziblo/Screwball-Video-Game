/// @desc prepare to draw pause surface
if (paused && !surface_exists(paused_surface) && paused_surface!=-1){
	//surface was already initialized but isn't anymore
	//reactivate so we can screenshot again.
	instance_activate_layer("Instances");
	//now we have to wait until the next event to screenshot
}
