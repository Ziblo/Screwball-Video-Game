/// @desc movement and tool use

//get player inputs
#region get inputs
	up_input=keyboard_check(ord("W"));
	down_input=keyboard_check(ord("S"));
	hinput=keyboard_check(ord("D"))-keyboard_check(ord("A")); //right is positive
	drop_input=keyboard_check(ord("Q"));
	use_input=keyboard_check(ord("E"));
#endregion

//detemine some conditions
#region conditions
	#region can_hold_tool
		can_hold_tool = (
			holding_inst==noone && 
			place_meeting(x+hsp,y+vsp,oTools_Parent) &&	
			no_regrab_timer==0 && 
			!dead &&
			use_input
		);
	#endregion
	#region on_ground
		on_ground =	place_meeting_or(x,y+3,collision_object_array);
	#endregion
	#region apply_gravity
		apply_gravity = ( 
			//!place_meeting_or(x,y+global.grav_accel,collision_object_array) &&
			cork_shoot_falling!=1
		);
	#endregion
#endregion

K_override = -1 + 1*(cork_shoot_falling==2);

//Apply player inputs
#region Process Inputs
	if(!dead){
		// basic movement //
		hsp=clamp(hsp+hinput*ground_accel,-h_top_speed,h_top_speed); //can accelerate to top speed
		vsp=clamp(vsp,-v_top_speed,v_top_speed);	//vsp within terminal velocity of v_top_speed
		
		// cork_shoot //
		if(in_shoe && up_input){//up inuput
			cork_shoot();
		}
		if(!in_shoe && vsp>0){//while falling w/out a shoe
			//either 1 or 2 depending on down input
			cork_shoot_falling=1+down_input;//fast fall
		}
		// TOOL INPUTS //
		if(drop_input && holding_inst!=noone){
			//drop tool
			drop_tool();
			//mass-=holding_inst.mass;
		}
		if(use_input && holding_inst!=noone){
			//use tool
			use_tool();
		}
		if(can_hold_tool){//if we're holding nothing and we collide with a tool
			//pick up tool
			holding_inst=instance_place(x+hsp,y+vsp,oTools_Parent)//save tool instance_id into holding_inst
			holding_obj=object_get_name(holding_inst.object_index); //what is the name of the tool we're holding? (for debugging)
		}
	}
	else{
		player_death();
}
#endregion

//Passive tool effects
#region Process Tools
	if(holding_inst!=noone){//if I'm holding something...
		//mass+=holding_inst.mass;
	}
	
	//no regrab timer
	if(no_regrab_timer>0){//if timer is going
		no_regrab_timer--;//continue to count down.
	}//otherwise the timer will rest at 0
	
#endregion

//Collisions and gravity
player_physics(collision_object_array);

//set sprites
player_animations();