// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_base_stats(_owner){
	var _hp = (argument_count > 1) ? argument[1] : 100;
	var _dam = (argument_count > 2) ? argument[2] : 10;
	with(_owner) {
		hp = _hp
	}
}