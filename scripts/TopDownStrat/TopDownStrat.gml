/// @func TopDownStrat([is_complex])
/// @param	{obj}	colliders			the colliders this object collides with
/// @param	{bool}	[is_complex]		whether to use simple or complex movement
function TopDownStrat(_colliders) constructor {
	var _is_complex = (argument_count > 1) ? argument[1] : true;
	
	_this = {
		is_complex: _is_complex,
		accel: 0,
		frict: 0,
		colliders: (is_array(_colliders)) ? _colliders : [_colliders],
		x_input: 0,
		y_input: 0
	};
	
	set_accel = function(_input) {
		_this.accel = _input;
	};
	
	set_frict = function(_input) {
		_this.frict = _input;
	};
	
	move_and_slide = function() {
		
	};
	
	
}