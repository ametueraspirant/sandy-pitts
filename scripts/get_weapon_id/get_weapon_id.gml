/// @func	get_weapon_id(_x, _y, _list);
/// @param	{int}	_x		x coord to search.
/// @param	{int}	_y		y coord to search.
/// @param	{list}	_list	ds_list input.
function get_weapon_id(_x, _y, _list) {
	instance_place_list(x + _x, y + _y, o_item_parent, _list, true);
}