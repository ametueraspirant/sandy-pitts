/// @func	collider(_obj, _collide, _bounce, _slide, _stick);
/// @param	{obj}	_obj		the collider object
/// @param	{bool}	_collide	whether it is solid
/// @param	{bool}	_bounce		whether it is bouncy
/// @param	{bool}	_slide		whether it will slide
/// @param	{bool}	_stick		whether it is sticky
function collider(_obj, _collide, _bounce, _slide, _stick) constructor {
	obj = _obj;
	collide = _collide;
	bounce = _bounce;
	slide = _slide;
	stick = _stick;
}

/// @func	set_base_stats(_max_spd, _accel, _frict);
/// @param	{int}	_max_spd	max movement speed
/// @param	{int}	_accel		acceleration
/// @param	{int}	_frict		friction
function set_base_stats(_max_spd, _accel, _frict) {
	with(other) {
		has_base_stats = true;
		max_spd = _max_spd;
		base_max_spd = _max_spd;
		accel = _accel;
		base_accel = _accel;
		frict = _frict;
		base_frict = _frict;
		colliding = false;
		sliding = false;
		sticking = false;
		input = true;
		uses_state_machine = false;
		spd = new Vector2(0, 0);
	}
}

function Vector2(_x, _y) constructor {
	x = _x;
	y = _y;
}