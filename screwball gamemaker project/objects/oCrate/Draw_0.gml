/// @desc 
draw_self();
var _c_x = x+sprite_width/2;
var _c_y = y+sprite_height/2;
draw_arrow(_c_x,_c_y,_c_x+10*hsp,_c_y+10*vsp,10);
if(db_col_occ){
	db_col_count += 1
}
