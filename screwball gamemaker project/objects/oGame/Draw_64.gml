/// @desc Healt Bubble
if (instance_exists(oPlayer)){
	draw_sprite_ext(sHealth_box,1,5,5,5,5,0,c_white,1)
	if (oPlayer.hp!=oPlayer.old_hp){
		hp_shake_timer=hp_shake_frames;
		vibrate=true;
	}
	if(oPlayer.hp==1){
		vibrate=true
	}
	var _x = 5+vibrate*(random(hp_shake_amount)-5);
	var _y = 5+vibrate*(random(hp_shake_amount)-5);
	draw_sprite_ext(sHealth,oPlayer.max_hp - oPlayer.hp,_x,_y,5,5,0,c_white,1);
	hp_shake_timer=max(hp_shake_timer-1,-1);
	if(hp_shake_timer==0){
		vibrate=false
	}
	oPlayer.old_hp=oPlayer.hp;
}
