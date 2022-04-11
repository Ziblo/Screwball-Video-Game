/// @desc create beam
event_inherited();

//every flashlight needs a beam
//save the instance id of this flashlight's particular beam
flashlight_beam_inst = instance_create_layer(x,y,"Instances",oFlashlight_beam);

beam_toggle=false; //initial beam state of the lught
