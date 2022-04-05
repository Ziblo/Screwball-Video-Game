/*
	Function table of contents:
		array_addition
		array_element_multiplication
		array_concatenate
		array_remove_values
		array_scalar
		magnitude
		place_meeting_or
		instance_place_or
		physics
		collision
		player_Physics
		player_collision
		collision_cork_shoot
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

function array_concatenate(array1,array2){
	//array3 = array1 ->CONCAT-> array2
	var array3=array_create(array_length(array1)+array_length(array2));//initialize array3
	for(var i=array_length(array1)-1; i>=0; --i){//loop over array1
		array3[i]=array1[i];
	}
	for(var i=array_length(array2)-1; i>=0; --i){//loop over array2
		array3[i+array_length(array1)]=array2[i];
	}
	return array3;
}

function array_remove_values(array1,array2){
	//take away the elements they have in common
	//in set theory: {array3} = {array1} - {array2}
	//basically the opposite of concatenate
	var match=0;
	var i=0;
	var array3=array_create(array_length(array1));
	var count=0;
	for(var i1=0; i1<=array_length(array1)-1; i1++){//loop over array1
		match=0;
		for(var i2=0; i2<=array_length(array2)-1; i2++){//loop over array2
			match=match||(array1[i1]==array2[i2]);//check across array2 and see if at least 1 is a match
		}
		count+=match;//add # of lost elements to count
		if(!match){
			array3[i]=array1[i1];
			i++;
		}
	}
	array_resize(array3,array_length(array1)-count);//resize array to account for lost elements
	return array3;
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
		//basically(hsp = hsp-frict) except it works in both directions and doesn't go past 0.
		hsp=sign(hsp)*max(abs(hsp)-frict,0);
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
	if(apply_gravity){
		vsp+=global.grav_accel;
	}
	
	//on_ground friction
	if(on_ground && !abs(hinput)){
		//basically(hsp = hsp-frict) except it works in both directions and doesn't go past 0.
		hsp=sign(hsp)*max(abs(hsp)-ground_frict,0);
	}
	
	//falling state
	switch (cork_shoot_falling){
	    case 1:
	        //fall at 1x cork_shoot_fall_vsp
			vsp=cork_shoot_fall_vsp;
			if(!abs(hinput)){
				//basically(hsp = hsp-frict) except it works in both directions and doesn't go past 0.
				hsp=sign(hsp)*max(abs(hsp)-air_frict,0);
			}
	        break;
		case 2:
			//fall at normal speed
			vsp+=global.grav_accel;
	    default:
	        // 0. Do nothing
	        break;
	}
	
	var _hsp=hsp;
	
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
		if(place_meeting_or(x+sign(hsp),y,collision_objects)){	//HORIZONTAL COLLISION
			player_collision(_instance,"h",K_override);
		}
		if(place_meeting_or(x,y+sign(vsp),collision_objects)){	//VERTICAL COLLISION
			if(sign(vsp)==1 && !in_shoe && !dead){//if we're landing without a shoe
				if(place_meeting(x,y+1,oShoe)){//if landing on a shoe
					player_collision(instance_place(x,y+1,oShoe),"v",1)//inelastic collision with shoe
					instance_destroy(instance_place(x,y+1,oShoe))//destroy shoe
					in_shoe=true;//we in da shoe now boiis B)
					cork_shoot_falling=false;
					sprite_index=sPlayer;
				}
				else{
					player_death();
				}
			}
			else{//if we're not landing without a shoe
				player_collision(_instance,"v",K_override);//v collide normally
			}
		}
	}
	
	//no friction if I'm trying to move
	if(abs(hinput))
		hsp=_hsp;//ignore collision hsp change if we're inputting
	
	//cork_shoot_cooldown
	if(cork_shoot_cooldown_timer>0){
		cork_shoot_cooldown_timer--;
	}
	else if(cork_shoot_cooldown_timer==0){
		collision_object_array=array_concatenate(collision_object_array,[oShoe]);
		cork_shoot_cooldown_timer--;//will now rest at -1
	}
	
	//corkshoot fall
	if(!in_shoe && vsp>0){//if I'm falling w/out a shoe
		cork_shoot_falling=true;//activate cork_shoot
	}
	
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
		if(place_meeting_or(x+hsp,y,collision_object_array)&&instance_place_or(x+hsp,y,collision_object_array)!=_instance){
			//collide with that object too
			var _inst_deeper=instance_place_or(x+hsp,y,collision_object_array);
			_depth++;
			player_collision(_inst_deeper,"h",-1,_depth);
		}
		if(place_meeting_or(x,y+vsp,collision_object_array)&&instance_place_or(x,y+vsp,collision_object_array)!=_instance){
			//collide with that object too
			var _inst_deeper=instance_place_or(x,y+vsp,collision_object_array);
			_depth++;
			player_collision(_inst_deeper,"v",-1,_depth);
		}

	}
}

function collision_cork_shoot(shoe_inst){
	//momentum problem
	//we're solving for it so that the player speed after is always the jump speed
	//(m1+m2)vi = m1v1+m2v2
	//v2 = (vi(m1+m2)-m1v1)/m2
	var _player_vsp_after_jump = -oPlayer.jump_speed;
	shoe_inst.vsp = (oPlayer.vsp*(oPlayer.mass+ shoe_inst.mass)-oPlayer.mass*(_player_vsp_after_jump))/shoe_inst.mass;
	shoe_inst.hsp = oPlayer.hsp; //hsp does not change
	oPlayer.vsp=_player_vsp_after_jump;
}