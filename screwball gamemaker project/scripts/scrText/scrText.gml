

function string_to_array(_string, _sep_char){
//this function takes a string and converts it to an array by finding _seperation_characters
	var _array_length = string_count(_sep_char, _string)+1;	//determine length of array
	var _array = array_create(_array_length);				//initialize the array
	var _pos1 = 1;											//initialize position 1
	for (var i = 0; i < _array_length; ++i){				//repeat for every cell except for last
		var _pos2 = string_pos_ext(_sep_char, _string, _pos1-1);	//find position of next seperation character
		if (_pos2 == 0){										//if we couldn't find another character
			_pos2 = string_length(_string)+1;
		}
		var _sub_length = _pos2 - _pos1;						//determine length of substring
		_array[i] = string_copy(_string, _pos1, _sub_length);	//copy cell into array
		_pos1 = _pos2+1;										//shift position 1 to next cell
	}
	return _array;
}
