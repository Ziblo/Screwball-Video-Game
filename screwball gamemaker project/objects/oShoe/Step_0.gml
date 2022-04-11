/// @desc use functionality

// Inherit the basic tool functionality
event_inherited();

if (used && !old_used){ //initial use
	//two options
	
	//Option 1: player doesn't have a shoe on
	if (!oPlayer.in_shoe){ //barefoot !	('o' !)
		//put on shoe
		with (oPlayer){
			//player_collision(instance_place(x,y+1,oShoe),"v",1)//inelastic collision with shoe
			cork_shoot_falling=0;
			in_shoe=true;//we in da shoe now boiis B)
			oPlayer.holding_inst = noone;
			instance_destroy(other);//destroy shoe
		}
	}
	//Option 2: player has a shoe already
	else{// we in a shoe
		//do nothing? :thinking_face:
	}
}
