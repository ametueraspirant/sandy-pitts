/// @func TopDownStrat(colliders, [is_complex], [accel], [frict])
/// @param	{obj}	colliders			the colliders this object collides with
/// @param	{bool}	[is_complex]		whether to use simple or complex movement
/// @param	{int}	[accel]				accel to use if movement is complex
/// @param	{int}	[frict]				frict to use if movement is complex
function TopDownStrat(_colliders) constructor {
	var _is_complex = (argument_count > 1) ? argument[1] : true;
	var _accel = (argument_count > 2) ? argument[2] : sprite_width * 0.1;
	var _frict = (argument_count > 3) ? argument[3] : sprite_width * 0.05;
	
	_this = {};
	
	with(_this) {
		is_complex = _is_complex;
		accel = (is_complex) ? _accel : 0;
		frict = (is_complex) ? _frict : 0;
		colliders = (is_array(_colliders)) ? _colliders : [_colliders];
		x_input = 0;
		y_input = 0;
	}
	
	set_accel = function(_input) {
		_this.accel = _input;
	};
	
	set_frict = function(_input) {
		_this.frict = _input;
	};
	
	move_and_slide = function() {
		
	};
	
	
}