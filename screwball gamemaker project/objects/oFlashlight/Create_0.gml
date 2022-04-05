/// @desc 

// Inherit the parent event
event_inherited();

//every flashlight needs a beam
instance_create_layer(x,y,"Instances",oFlashlight_beam);
//save the instance id of this flashlight's particular beam
flashlight_beam_inst=instance_id_get(instance_count-1);

beam_toggle=false;
just_used=false;
