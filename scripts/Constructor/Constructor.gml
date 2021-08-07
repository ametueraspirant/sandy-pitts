/// @author	Amet
/// @desc	a constructor containing many functions. It is state machine and input system agnostic, and works well with most existing ones that I know of.
/// @func	TopDownStrat(colliders, [is_complex], [accel], [frict])
/// @param	{bool}	[is_complex]		whether to use simple or complex movement
function TopDownStrat() constructor {
	var _is_complex = (argument_count > 0) ? argument[0] : TDS_DEFAULT_COMPLEXITY;
	var _owner = other.id;
	
	_this = {};
	
	with(_this) {
		owner = _owner;
		is_complex = _is_complex;
		colliders = [];
		timers = [];
	}
	
	if(!_this.owner.has_base_stats) {
		show_debug_message("you haven't set your stats up. consider using the set_base_stats function to initialize all of the stats this object will use.");
	}
	
	#region /// internal functions, not meant to be used externally
	///	@func	_add_to_array(_obj, _arr);
	/// @param	{arr}	_obj	the item to add to the array
	/// @param	{arr}	_arr	the array to add to
	_add_to_array = function(_obj, _arr) {
		for(var int = 0; int < array_length(_arr); int++) {
			if(_arr[int] == _obj)return show_debug_message("that collider already exists. did you mean to modify?");
		}
		array_push(_arr, _obj);
	}
	
	///	@func	_delete_from_array(_obj, _arr);
	/// @param	{arr}	_obj	the item to delete from the array
	/// @param	{arr}	_arr	the array to delete from
	_delete_from_array = function(_obj, _arr) {
		var exists = true;
		for(var int = 0; int < array_length(_arr); int++) {
			if(_arr[int] == _obj) {
				array_delete(_arr, int, 1);
				exists = false;
			}
		}
		if(!exists)return show_debug_message("you haven't added a collider with that name");
	}
	 
	#endregion
	
	#region // functions for changing base stats after creation
	///	@func	accel_set(_accel);
	/// @param	{int}	_accel		the accel value to set
	accel_set = function(_accel) {
		_this.owner.accel = _accel;
		_this.owner.base_accel = _accel;
	}
	
	/// @func	accel_set_temp(_accel);
	/// @param	{int}	_accel	the accel value to temporarily change to
	accel_set_temp = function(_accel) {
		_this.owner.accel = _accel;
	}
	
	/// @func	accel_reset();
	accel_reset = function() {
		_this.owner.accel = this.owner.base_accel;
	}
	
	///	@func	frict_set(_frict)
	/// @param	{int}	_frict		the frict value to set
	frict_set = function(_frict) {
		_this.owner.frict = _frict;
		_this.owner.base_frict = _frict;
	}
	
	/// @func	frict_set_temp(_frict);
	/// @param	{int}	_frict	the frict value to temporarily change to
	frict_set_temp = function(_frict) {
		_this.owner.frict = _frict;
	}
	
	/// @func frict_reset();
	frict_reset = function(_frict) {
		_this.owner.frict = _this.owner.base_frict;
	}
	
	///	@func	max_spd_set(_max_spd);
	/// @param	{int}	_max_spd	the max_spd value to set
	max_spd_set = function(_max_spd) {
		_this.owner.max_spd = _max_spd;
		_this.owner.base_max_spd = _max_spd;
	};
	
	/// @func	max_spd_set_temp(_max_spd);
	/// @param	{int}	_max_spd	the max_spd value to temporarily change to
	max_spd_set_temp = function(_max_spd) {
		_this.owner.max_spd = _max_spd;
	}
	
	/// @func	max_spd_reset();
	max_spd_reset = function() {
		_this.owner.max_spd = _this.owner.base_max_spd;
	}
	
	/// @func input_enable();
	input_enable = function() {
		_this.owner.input = true;
	}
	
	/// @func input_disable();
	input_disable = function() {
		_this.owner.input = false;
	}
	#endregion
	
	#region // functions for modifying colliders
	/// @func	add_collider();
	/// @param	{obj}		_obj				the collider object
	/// @param	{string}	_collider_type		the type of collider to set it to
	add_collider = function(_obj, _collider_type) {
		var col = (is_array(_obj)) ? _obj : [_obj];
		for(var int = 0; int < array_length(col); int++) {
			switch(_collider_type) {
				case "collide":
				_add_to_array(new collider(col[int], true, false, false, false) , _this.colliders);
				break;
				
				case "bounce":
				_add_to_array(new collider(col[int], false, true, false, false) , _this.colliders);
				break;
				
				case "slide":
				_add_to_array(new collider(col[int], false, false, true, false) , _this.colliders);
				break;
				
				case "stick":
				_add_to_array(new collider(col[int], false, false, false, true) , _this.colliders);
				break;
				
				default:
				show_debug_message("That's not a valid collider type, please enter: collide, bounce, slide, or stick as a string.");
				break;
			}
		}
	}
	
	/// @func delete_collider
	/// @param	{obj}	the collider object
	delete_collider = function(_obj) {
		var col = (is_array(_obj)) ? _obj : [_obj];
		for(var int = 0; int < array_length(col); int++) {
			_delete_from_array(col[int], _this.colliders);
		}
	}
	
	/// @func modify_collider();
	/// @param	{obj}		_obj				the collider object
	/// @param	{string}	_collider_type		the type of collider to set it to
	modify_collider = function(_obj, _collider_type) {
		delete_collider(_obj);
		add_collider(_obj, _collider_type);
	}
	#endregion
	
	#region /// timer system functions
	/// @func	timer_get(_name);
	/// @param	{str}	_name	the name of the timer
	timer_get = function(_name) {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].name == _name) {
				return [_this.timers[int], int];
			}
		}
		return false;
	}
	
	/// @func	timer_set(_dur, _func);
	/// @param	{int}	_dur	the duration of the timer to set
	/// @param	{str}	_name	the name of the timer
	/// @param	{func}	_func	the function to run when the timer runs out
	timer_set = function(_dur, _name, _func) {
		if(!is_array(timer_get(_name)))array_push(_this.timers, new timer(_dur, _name, _func));
		return true;
	}
	
	/// @func	timer_execute_early(_name);
	/// @param	{str}	_name	the name of the timer
	timer_execute_early = function(_name) {
		var _timer = timer_get(_name);
		if(is_array(_timer)) {
			_timer[0].func();
			array_delete(_this.timers, _timer[1], 1);
			show_debug_message("timer has been executed early and deleted from the list.");
			return true;
		} else {
			show_debug_message("no timer exists with this name.");
			return false;
		};
	}
	
	/// @func	timer_exists(_name);
	/// @param	{str}	_name	the name of the timer
	timer_exists = function(_name) {
		var _timer = timer_get(_name);
		if(is_array(_timer)) {
			return true;
		} else {
			return false;
		}
	}
	
	/// @func	timer_get_remaining_time(_name);
	/// @param	{str}	_name	the name of the timer
	timer_get_remaining_time = function(_name) {
		var _timer = timer_get(_name);
		if(is_array(_timer)) {
			return _timer[0].time + _timer[0].dur - current_time;
		} else {
			show_debug_message("no timer exists with this name.");
			return false;
		}
	}
		
	/// @func	check_timers();
	check_timers = function() {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].time + _this.timers[int].dur <= current_time) {
				_this.timers[int].func();
				array_delete(_this.timers, int, 1);
			}
		}
	}
	#endregion
	
	#region /// collision functions, not meant to be used externally
	
	/// @func	_collide(_col);
	/// @param	{obj}	_col	the object collider to check for
	_collide = function(_col) {
		with(_this.owner) {
			if(!place_meeting(x + spd.x, y + spd.y, _col)) {
				colliding = false;
				return false;
			}
			if(place_meeting(x + spd.x, y, _col)) {
				while(!place_meeting(x + sign(spd.x), y, _col)) {
					x += sign(spd.x);
				}
				spd.x = 0;
			}
			if(place_meeting(x + spd.x, y + spd.y, _col)) {
				while(!place_meeting(x + spd.x, y + sign(spd.y), _col)) {
					y += sign(spd.y);
				}
				spd.y = 0;
			}
			colliding = true;
			return true;
		}
	}
	
	/// @func	_bounce(_col);
	/// @param	{obj}	_col	the object collider to check for
	_bounce = function(_col) {
		with(_this.owner) {
			if(place_meeting(x + spd.x, y + spd.y, _col)) {
				spd.x = -spd.x * 0.5;
				spd.y = -spd.y * 0.5;
				input = false;
				other.timer_set(300, TDS_TIMERS.BOUNCE, function() {
					spd.x = 0;
					spd.y = 0;
					input = true;
				});
			}
		}
	}
	
	
	
	/// @func	_slide(_col);
	/// @param	{obj}	_col	the object collider to check for
	_slide = function(_col) {
		with(_this.owner) {
			if(sticking) {
				sliding = false;
				return;
			}
			if(place_meeting(x, y, _col)) {
				frict = 0;
				accel = base_accel * 0.5;
				max_spd = base_max_spd;
				sliding = true;
			} else {
				max_spd = base_max_spd;
				accel = base_accel;
				frict = base_frict;
				sliding =  false;
			}
		}
	}
	
	/// @func	_stick(_col);
	/// @param	{obj}	_col	the object collider to check for
	_stick = function(_col) {
		with(_this.owner) {
			if(sliding) {
				sticking = false;
				return;
			}
			if(place_meeting(x, y, _col)) {
				max_spd = base_max_spd * 0.6;
				accel = base_accel * 0.5;
				frict = base_frict;
				sticking = true;
			} else {
				max_spd = base_max_spd;
				accel = base_accel;
				frict = base_frict;
				sticking = false;
			}
		}
	}
	#endregion
	
	#region /// state change listener functions
	/// @func	is_moving();
	is_moving = function() {
		return (_this.owner.spd.x != 0 || _this.owner.spd.y != 0);
	}
	
	/// @func	is_colliding();
	is_colliding = function() {
		return _this.owner.colliding;
	}
	
	/// @func	is_bouncing();
	is_bouncing = function() {
		return timer_exists(TDS_TIMERS.BOUNCE);
	}
	
	/// @func	is_sliding();
	is_sliding = function() {
		return _this.owner.sliding;
	}
	
	/// @func	is_sticking();
	is_sticking = function() {
		return _this.owner.sticking;
	}
	
	/// @func	is_dashing();
	is_dashing = function() {
		return timer_exists(TDS_TIMERS.DASH);
	}
	
	/// @func is_idle();
	is_idle = function() {
		if(!is_moving() 
		&& !is_colliding()
		&& !is_bouncing()
		&& !is_sliding()
		&& !is_sticking()
		&& !is_dashing()){
			return true;
		} else {
			return false;
		}
	}
	#endregion
	
	#region // movement helper functions
	///	@func	dash(x_dir, y_dir);
	///	@param	{int}	x_dir	the x direction of inputs
	/// @param	{int}	y_dir	the y direction of inputs
	dash = function(mv_dir, mv_mag) {
		if(timer_exists(TDS_TIMERS.DASH) || timer_exists(TDS_TIMERS.DASH_COOLDOWN))return;
		with(_this.owner) {
			other.move(mv_dir, mv_mag * 15);
		}
		input_disable();
		timer_set(150, TDS_TIMERS.DASH, function() {
			with(_this.owner) {
				spd.x = sign(spd.x) * max_spd;
				spd.y = sign(spd.y) * max_spd;
			}
			input_enable();
			timer_set(850, TDS_TIMERS.DASH_COOLDOWN, function() {
				// nothing here, timer just needs to exist.
			});
		});
	}
	
	/// @func	move(mv_dir);
	///	@param	{int}	mv_dir	the direction of the movement vector
	/// @param	{int}	mv_mag	the magnitude of the movement vector
	move = function(mv_dir, mv_mag) {
		var x_dir = lengthdir_x(mv_mag, mv_dir);
		var y_dir = lengthdir_y(mv_mag, mv_dir);
		
		check_timers();
		
		if(_this.owner.input) {
			if(_this.is_complex) {
				if(abs(_this.owner.spd.x) < abs(lengthdir_x(abs(x_dir), mv_dir) * _this.owner.max_spd)) {
					_this.owner.spd.x += lengthdir_x(abs(x_dir) * _this.owner.accel, mv_dir) - sign(_this.owner.spd.x) * _this.owner.frict;
				} else {
					_this.owner.spd.x -= sign(_this.owner.spd.x) * _this.owner.frict;
				}
				if(x_dir = 0 && abs(_this.owner.spd.x) < 0.1)_this.owner.spd.x = 0;
				
				if(abs(_this.owner.spd.y) < abs(lengthdir_y(abs(y_dir), mv_dir) * _this.owner.max_spd)) {
					_this.owner.spd.y += lengthdir_y(abs(y_dir) * _this.owner.accel, mv_dir) - sign(_this.owner.spd.y) * _this.owner.frict;
				} else {
					_this.owner.spd.y -= sign(_this.owner.spd.y) * _this.owner.frict;
				}			
				if(y_dir = 0 && abs(_this.owner.spd.y) < 0.1)_this.owner.spd.y = 0;
			} else {
				_this.owner.spd.x = lengthdir_x(abs(x_dir), mv_dir) * _this.owner.max_spd;
				_this.owner.spd.y = lengthdir_y(abs(y_dir), mv_dir) * _this.owner.max_spd;
			}
		}
		
		if(mv_mag == 0) {
			if(abs(_this.owner.spd.x) < 0.2)_this.owner.spd.x = 0;
			if(abs(_this.owner.spd.y) < 0.2)_this.owner.spd.y = 0;
		}

		for(var int = 0; int < array_length(_this.colliders); int++) {
			var _col = _this.colliders[int];
			if(_col.slide)_slide(_col.obj);
			if(_col.stick)_stick(_col.obj);
			if(_col.bounce)_bounce(_col.obj);
			if(_col.collide)_collide(_col.obj);
		}
		
		_this.owner.x += _this.owner.spd.x;
		_this.owner.y += _this.owner.spd.y;
	}
	#endregion
}