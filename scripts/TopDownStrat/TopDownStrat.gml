/// @func TopDownStrat([is_complex])
/// @param	{bool} is complex		whether to use simple or complex movement
function TopDownStrat() constructor {
	var _is_complex = (argument_count > 1) ? argument[1] : false;
	_this = {
		is_complex: _is_complex,
		accel: 0,
		frict: 0
		
	}
}