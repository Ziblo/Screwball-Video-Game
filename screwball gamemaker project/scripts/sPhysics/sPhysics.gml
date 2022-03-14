/*
	Function table of contents:
		array_addition
		array_element_multiplication
		array_scalar
		magnitude
		place_meeting_or
		Physics
		collision
		Player_Physics
		player_collision
*/

function array_addition(array1,array2){
	if(array_length(array1)!=array_length(array2)){
		show_error("arrays not same length",true);
	}
	for(var i=array_length(array1)-1; i>=0; --i){
		array1[i]=array1[i]+array2[i];
	}
	return array1;
}

function array_element_multiplication(array1,array2){
	if(array_length(array1)!=array_length(array2)){
		show_error("arrays not same length",true);
	}
	for(var i=array_length(array1)-1; i>=0; --i){
		array1[i]=array1[i]*array2[i];
	}
	return array1;
}

function array_scalar(scalar,array){
///@param {real} scalar
///@param {array} array
	for(var i=array_length(array)-1; i>=0; --i){
		array[i]=scalar*array[i];
	}
	return array;
}

function magnitude(a,b=0){
	if(is_array(a)){
		b=a[1];//if a is an array, ignore b and use first two elements of a
		a=a[0];
	}
	return sqrt(a*a+b*b);	//thank you, pythagoras
}

function place_meeting_or(x,y,objects){
///@param {real} x
///@param {real} y
///@param {array} objects
	var boolean=false;
	for(var i=array_length(objects)-1; i>=0; --i){
		boolean = boolean || place_meeting(x,y,objects[i]);//OR it with every place_meeting(obj)
	}
	return boolean;
}

function instance_place_or(x,y,objects){
///@param {real} x
///@param {real} y
///@param {array} objects
	var inst = noone
	for(var i=array_length(objects)-1; i>=0; --i){
		if(place_meeting(x,y,objects[i])){//if there is a hit
			inst=instance_place(x,y,objects[i])//record that value to inst
		}//this prioritizes the first objects in the list over the later ones if 2 or more objects are found
	}
	return inst;
}

function physics(collision_objects=[oSolid]){
///@funct			physics()
///@desc			Process inanimate objects physics.
///@param {array} collision_objects

	//gravity
	if(!place_meeting_or(x,y+vsp+global.grav_accel,collision_objects)){
		vsp+=global.grav_accel;
	}
	
	//on ground check
	on_ground=place_meeting_or(x,y+3,collision_objects);
	
	//on_ground friction
	if(on_ground){
		//basically(hsp -= hsp*frict) except it works in both directions and doesn't go past 0.
		//hsp loses a fraction of it's magnitude every frame
		hsp=sign(hsp)*max(abs(hsp)*(1-frict),0);
	}
	
	//colliding with another solid
	if(place_meeting_or(x+hsp,y+vsp,collision_objects)){
		var _instance=instance_place_or(x+hsp,y+vsp,collision_objects); //get what it is you're colliding with
		
		//we're gonna go forward by one unit and check if we're colliding until we either reach the distance we would've traveled in that frame anyway, or we hit an object.
		var _dA=array_scalar(1/magnitude(hsp,vsp),[hsp,vsp]); //determine unit vector of velocity.
		var _D=magnitude(hsp,vsp);//total distance you would travel in that one frame
		var _d=0//distance you will traveled checking for collisions.
		while(!place_meeting_or(x+_dA[0],y+_dA[1],collision_objects) && _d<_D){
			x+=_dA[0];//inch forward at same slope
			y+=_dA[1];
			_d++;//we have traveled 1 unit in the direction of velocity.
		}
		if(place_meeting_or(x+sign(hsp),y,collision_objects)){
			collision(_instance,"h",K_override);
		}
		if(place_meeting_or(x,y+sign(vsp),collision_objects)){
			collision(_instance,"v",K_override);
		}
	}
	
	//make sure we're not going into any blocks still. (failsafe)
	if(!place_meeting_or(x+hsp,y,collision_objects))//if the coast is clear, or it's only got an ignore-object
		x+=hsp;
	else
		hsp=0;
	if(!place_meeting_or(x,y+vsp,collision_objects))
		y+=vsp;
	else
		vsp=0;
}

function collision(_instance,h_or_v,_K=-1,_depth=0){
///@funct			collision(instance, h or v, K override)
///@desc			Process collisions. -K values 
///@param {real} inst_id
///@param {string} h_or_v
///@param {real} energy_loss %

	//I modeled this calculation in desmos. Here's the link to the desmos thing. x and y are v1 and v2
	//https://www.desmos.com/calculator/1ojihotgfz
	if(_K<0)//if override not active
		_K=min(magnitude(energy_loss,_instance.energy_loss)/1.2,1);//energy lost in collision compares the two constants. the 1.2 can go up sqrt(2) or as low as 1 to adjust

	//which side to solve for
	switch(h_or_v){
		case "h":
			h_or_v=1;
			break;
		case "v":
			h_or_v=-1;
			break;
		default:
			show_error("collision axis not specified",true);
	}
	
	//static vs kinetic friction
	//kinetic friction is built into the energy loss. (collision loses energy on collision axis and shear axis)
	var _relative_hsp=hsp-_instance.hsp;
	var _relative_vsp=vsp-_instance.vsp;
	//if relative speed is low enough, static friction.
	if(abs(_relative_vsp)<.1)//basic version of static friction based on only speed.
		vsp=_instance.vsp;
	if(abs(_relative_hsp)<.1)
		hsp=_instance.hsp;
		
	//horizontal
	var v1=hsp;
	var v2=_instance.hsp;
	var mass_ratio=mass/_instance.mass;
	var _Kh=_K*.5*mass*_instance.mass*sqr(v1-v2)/(mass+_instance.mass);
	var a=1+mass_ratio;
	var b=-2*mass_ratio*v1-2*v2;
	var c=(v1*v1)*(mass_ratio-1)+2*v2*v1+2*_Kh/mass;
	var _sqrt=b*b-4*a*c;
	if(_sqrt<=0)
		_sqrt=0;
	hsp=(b+h_or_v*sign(v1-v2)*sqrt(_sqrt))/(-2*a);
	_instance.hsp=v2+mass_ratio*(v1-hsp);
	
	//vertical
	var v1=vsp;
	var v2=_instance.vsp;
	var mass_ratio=mass/_instance.mass;
	var _Kv=_K*.5*mass*_instance.mass*sqr(v1-v2)/(mass+_instance.mass);
	var a=1+mass_ratio;
	var b=-2*mass_ratio*v1-2*v2;
	var c=(v1*v1)*(mass_ratio-1)+2*v2*v1+2*_Kv/mass;
	var _sqrt=b*b-4*a*c;
	if(_sqrt<=0)
		_sqrt=0;
	vsp=(b-h_or_v*sign(v1-v2)*sqrt(_sqrt))/(-2*a);
	_instance.vsp=v2+mass_ratio*(v1-vsp);
	
	//round down to 0 when bounce is negligible
	if(abs(vsp)<.1)
		vsp=0;
	if(abs(hsp)<.1)
		hsp=0;
	if(abs(_instance.vsp)<.1)
		_instance.vsp=0;
	if(abs(_instance.hsp)<.1)
		_instance.hsp=0;
	
	
	if(_depth<3){//this controls the amount of times the function can call itself
					//...which basically limits the amount of instances any one collision can look at
		//between two solids horizontally
		if(place_meeting(x+hsp,y,oSolid)&&instance_place(x+hsp,y,oSolid)!=_instance){
			//collide with other solid
			var _inst_deeper=instance_place(x+hsp,y,oSolid);
			_depth++;
			collision(_inst_deeper,"h",-1,_depth);
		}
		//between two solids verically
		if(place_meeting(x,y+vsp,oSolid)&&instance_place(x+hsp,y,oSolid)!=_instance){
			//collide with other solid
			var _inst_deeper=instance_place(x,y+vsp,oSolid);
			_depth++;
			collision(_inst_deeper,"v",-1,_depth);
		}
	}
}

function player_physics(collision_objects=[oSolid]){
///@funct			player_physics()
///@desc			Process player physics movement.
///@param {array} collision_objects

	//gravity
	if(!place_meeting_or(x,y+vsp+global.grav_accel,collision_objects)){
		vsp+=global.grav_accel;
	}
	
	//on ground check
	on_ground=place_meeting_or(x,y+3,collision_objects);
	
	//on_ground friction
	if(on_ground && !abs(hinput)){
		//basically(hsp -= hsp*frict) except it works in both directions and doesn't go past 0.
		//hsp loses a fraction of it's magnitude every frame
		hsp=sign(hsp)*max(abs(hsp)*(1-frict),0);
	}
	
	//process player inputs into movement
	hsp=clamp(hsp+hinput*ground_accel,-h_top_speed,h_top_speed); //can accelerate to top speed
	vsp=clamp(vsp,-v_top_speed,v_top_speed);	//gravity within terminal velocity of v_top_speed
	var _hsp=hsp;
	//jumping
	if(on_ground && vinput==-1){//up
		vsp=-jump_speed;
		in_shoe=false;
		instance_create_layer(x,y,"Instances",oShoe);
		
	}
	
	//colliding with another solid
	if(place_meeting_or(x+hsp,y+vsp,collision_objects)){
		var _instance=instance_place_or(x+hsp,y+vsp,collision_objects); //get what it is you're colliding with
		var _dA=array_scalar(1/magnitude(hsp,vsp),[hsp,vsp]); //determine normal vector of velocity.
		var _D=magnitude(hsp,vsp);//total distance you would travel in that one frame
		var _d=0//distance you will traveled checking for collisions.
		while(!place_meeting_or(x+_dA[0],y+_dA[1],collision_objects) && _d<_D){
			x+=_dA[0];//inch forward at same slope
			y+=_dA[1];
			_d++;//we have traveled 1 unit in the direction of velocity.
		}
		if(place_meeting_or(x+sign(hsp),y,collision_objects)){
			player_collision(_instance,"h",K_override);
		}
		if(place_meeting_or(x,y+sign(vsp),collision_objects)){
			player_collision(_instance,"v",K_override);
		}
	}
	
	if(abs(hinput))
		hsp=_hsp;
	
	//make sure we're not going into any blocks still. (failsafe)
	if(!place_meeting_or(x+hsp,y,collision_objects))
		x+=hsp;
	else
		hsp=0;
	if(!place_meeting_or(x,y+vsp,collision_objects))
		y+=vsp;
	else
		vsp=0;
}

function player_collision(_instance,h_or_v,_K=-1,_depth=0){
///@funct			player_collision(instance, h or v, K override)
///@desc			Process collisions. -K values 
///@param {real} inst_id
///@param {string} h_or_v
///@param {real} energy_loss %

	//I modeled this calculation in desmos. Here's the link to the desmos thing. x and y are v1 and v2
	//https://www.desmos.com/calculator/1ojihotgfz
	
	/*
	  var _hsp_b4=hsp;
	  var _ihsp_b4=_instance.hsp;
	  var _vsp_b4=vsp;
	  var _ivsp_b4=_instance.vsp;
	*/
	
	if(_K<0)//if override not active
		_K=min(magnitude(energy_loss,_instance.energy_loss)/1.2,1);//energy lost in collision compares the two constants. the 1.2 can go up sqrt(2) or as low as 1 to adjust

	//which side to solve for
	switch(h_or_v){
		case "h":
			//horizontal collision
			var v1=hsp;
			var v2=_instance.hsp;
			var mass_ratio=mass/_instance.mass;
			var _Kh=_K*.5*mass*_instance.mass*sqr(v1-v2)/(mass+_instance.mass);
			var a=1+mass_ratio;
			var b=-2*mass_ratio*v1-2*v2;
			var c=(v1*v1)*(mass_ratio-1)+2*v2*v1+2*_Kh/mass;
			var _sqrt=b*b-4*a*c;
			if(_sqrt<=0)
				_sqrt=0;
			hsp=(b+sign(v1-v2)*sqrt(_sqrt))/(-2*a);
			_instance.hsp=v2+mass_ratio*(v1-hsp);
			
			//vertical energy loss
			var v1=vsp;
			var v2=_instance.vsp;
			var mass_ratio=mass/_instance.mass;
			var _Kv=_K*.5*mass*_instance.mass*sqr(v1-v2)/(mass+_instance.mass);
			var a=1+mass_ratio;
			var b=-2*mass_ratio*v1-2*v2;
			var c=(v1*v1)*(mass_ratio-1)+2*v2*v1+2*_Kv/mass;
			var _sqrt=b*b-4*a*c;
			if(_sqrt<=0)
				_sqrt=0;
			vsp=(b-sign(v1-v2)*sqrt(_sqrt))/(-2*a);//minus instead of plus
			_instance.vsp=v2+mass_ratio*(v1-vsp);
			
			break;
		case "v":
			//vertical collision
			_K=_K;//more vertical energy loss in vertical collisions
			var v1=vsp;
			var v2=_instance.vsp;
			var mass_ratio=mass/_instance.mass;
			var _Kv=_K*.5*mass*_instance.mass*sqr(v1-v2)/(mass+_instance.mass);
			var a=1+mass_ratio;
			var b=-2*mass_ratio*v1-2*v2;
			var c=(v1*v1)*(mass_ratio-1)+2*v2*v1+2*_Kv/mass;
			var _sqrt=b*b-4*a*c;
			if(_sqrt<=0)
				_sqrt=0;
			vsp=(b+sign(v1-v2)*sqrt(_sqrt))/(-2*a);
			_instance.vsp=v2+mass_ratio*(v1-vsp);
			
			//horizontal energy loss
			_K=_K/2;//less horizontal energy loss in vertical collisions
			var v1=hsp;
			var v2=_instance.hsp;
			var mass_ratio=mass/_instance.mass;
			var _Kh=_K*.5*mass*_instance.mass*sqr(v1-v2)/(mass+_instance.mass);
			var a=1+mass_ratio;
			var b=-2*mass_ratio*v1-2*v2;
			var c=(v1*v1)*(mass_ratio-1)+2*v2*v1+2*_Kh/mass;
			var _sqrt=b*b-4*a*c;
			if(_sqrt<=0)
				_sqrt=0;
			hsp=(b-sign(v1-v2)*sqrt(_sqrt))/(-2*a); //minus instead of plus
			_instance.hsp=v2+mass_ratio*(v1-hsp);
			break;
		default:
			show_error("collision axis not specified",true);
	}
	
	//static vs kinetic friction
	//kinetic friction is built into the energy loss. (collision loses energy on collision axis and shear axis)
	var _relative_hsp=hsp-_instance.hsp;
	var _relative_vsp=vsp-_instance.vsp;
	//if relative speed is low enough, static friction.
	if(abs(_relative_vsp)<.1)//basic version of static friction based on only speed.
		vsp=_instance.vsp;
	if(abs(_relative_hsp)<.1)
		hsp=_instance.hsp;
	
	//round down to 0 when bounce is negligible
	if(abs(vsp)<.1)
		vsp=0;
	if(abs(hsp)<.1)
		hsp=0;
	if(abs(_instance.vsp)<.1)
		_instance.vsp=0;
	if(abs(_instance.hsp)<.1)
		_instance.hsp=0;
	
	
	if(_depth<5){//this controls the amount of times the function can call itself
					//...which basically limits the amount of instances any one collision can look at
		
		/* not actualy needed because this is processed in the instance's step event
		//_instance is between another solid and player
		if(place_meeting(_instance.x+_instance.hsp,_instance.y,oSolid)&&!place_meeting(_instance.x,_instance.y,oSolid)){//said object is also not already clipping (like bounding walls)
			//pretend to collide with secondary instance instead
			var _inst_deeper=instance_place(_instance.x+_instance.hsp,_instance.y,oSolid);
			hsp=_hsp_b4;
			_depth++;
			player_collision(_inst_deeper,"h",-1,_depth)
		}
		if(place_meeting(_instance.x,_instance.y+_instance.vsp,oSolid)&&!place_meeting(_instance.x,_instance.y,oSolid)){
			//pretend to collide with secondary instance instead
			var _inst_deeper=instance_place(_instance.x,_instance.y+_instance.vsp,oSolid);
			vsp=_vsp_b4;
			_depth++;
			player_collision(_inst_deeper,"v",-1,_depth)
		}*/
		
		//player between two objects
		if(place_meeting(x+hsp,y,oSolid)&&instance_place(x+hsp,y,oSolid)!=_instance){
			//collide with that object too
			var _inst_deeper=instance_place(x+hsp,y,oSolid);
			_depth++;
			player_collision(_inst_deeper,"h",-1,_depth);
		}
		if(place_meeting(x,y+vsp,oSolid)&&instance_place(x,y+vsp,oSolid)!=_instance){
			//collide with that object too
			var _inst_deeper=instance_place(x,y+vsp,oSolid);
			_depth++;
			player_collision(_inst_deeper,"v",-1,_depth);
		}

	}
}