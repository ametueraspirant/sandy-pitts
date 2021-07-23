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

/// @func	timer(_dur, _func);
/// @param	{int}	_dur	the duration of the timer in frames
/// @aparam	{func}	_func	the function to run when the timer duration runs out
function timer(_dur, _func) constructor {
	time = current_time;
	dur = _dur;
	func = _func;
}

// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_base_stats(_hp, _damage, _max_spd, _accel, _frict){
	with(other) {
		has_base_stats = true;
		hp = _hp;
		dam = _damage;
		max_spd = _max_spd;
		base_max_spd = _max_spd;
		accel = _accel;
		base_accel = _accel;
		frict = _frict;
		base_frict = _frict;
		is_colliding = false;
		input = true;
		uses_state_machine = false;
		spd = new Vector2(0, 0);
	}
}

function Vector2(_x, _y) constructor{
	x = _x;
	y = _y;
}

function YSort(){
	
}