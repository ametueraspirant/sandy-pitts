/// @func	TopDownStrat(colliders, [is_complex], [accel], [frict])
/// @param	{bool}	[is_complex]		whether to use simple or complex movement
function TopDownStrat() constructor {
	var _is_complex = (argument_count > 0) ? argument[0] : true;
	var _owner = other.id;
	
	_this = {};
	
	with(_this) {
		is_complex = _is_complex;
		owner = _owner;
		colliders = [];
		timers = [];
	}
	
	if(!_this.owner.has_base_stats) {
		show_debug_message("you haven't set your stats up. consider using the set_base_stats function to initialize all of the stats this object will use.");
	}
	
	#region /// internal functions, not meant to be used externally
	///	@func	_add_to_array(_col, _arr);
	/// @param	{arr}	_col	the item to add to the array
	/// @param	{arr}	_arr	the array to add to
	_add_to_array = function(_col, _arr) {
		for(var int = 0; int < array_length(_arr); int++) {
			if(_arr[int] == _col)return show_debug_message("that collider already exists. did you mean to modify?");
		}
		array_push(_arr, _col);
	}
	
	///	@func	_delete_from_array(_col, _arr);
	/// @param	{arr}	_col	the item to delete from the array
	/// @param	{arr}	_arr	the array to delete from
	_delete_from_array = function(_col, _arr) {
		var exists = false;
		for(var int = 0; int < array_length(_arr); int++) {
			if(_arr[int] == _col) {
				array_delete(_arr, int, 1);
				exists = true;
			}
		}
		if(exists)return show_debug_message("you haven't added a collider with that name");
	}
	 
	#endregion
	
	#region // functions for changing base stats after creation
	///	@func	set_accel(_accel);
	/// @param	{int}	_accel		the accel value to set
	set_accel = function(_accel) {
		_this.owner.accel = _accel;
		_this.owner.base_accel = _accel;
	};
	
	///	@func	set_frict(_frict)
	/// @param	{int}	_frict		the frict value to set
	set_frict = function(_frict) {
		_this.owner.frict = _frict;
		_this.owner.base_frict = _frict;
	};
	
	///	@func	set_max_spd(_max_spd);
	/// @param	{int}	_max_spd	the max_spd value to set
	set_max_spd = function(_max_spd) {
		_this.owner.max_spd = _max_spd;
		_this.owner.base_max_spd = _max_spd;
	};
	
	/// @func set_input_true();
	set_input_true = function() {
		_this.owner.input = true;
	}
	
	/// @func set_input_false();
	set_input_false = function() {
		_this.owner.input = false;
	}
		
	/// @func	set_hp(_hp);
	/// @param	{int}	_hp		the hp value to add or subtract.
	set_hp = function(_hp) {
		_this.owner.hp = clamp(_this.owner.hp + _hp, 0, _this.owner.max_hp);
	}
	
	/// @func	set_max_hp(_max_hp);
	/// @param	{int}	_max_hp		the max_hp value to set
	set_max_hp = function(_max_hp) {
		_this.owner.max_hp = _max_hp;
	}
	
	/// @func	set_damage(_damage);
	/// @param	{int}	_damage		the damage value to set
	set_damage = function(_damage) {
		_this.owner.dam = _damage;
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
	/// @func	timer_set(_dur, _func);
	/// @param	{int}	_dur	the duration of the timer to set
	/// @param	{str}	_name	the name of the timer
	/// @param	{func}	_func	the function to run when the timer runs out
	timer_set = function(_dur, _name, _func) {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].name == _name) {
				return show_debug_message("a timer with this name already exists.");
			}
		}
		array_push(_this.timers, new timer(_dur, _name, _func));
	}
	
	/// @func	timer_get(_name);
	/// @param	{str}	_name	the name of the timer
	timer_get = function(_name) {
		if(!is_string(_name))return show_debug_message("make sure the name is a string");
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].name == _name) {
				return _this.timers[int];
			} else {
				show_debug_message("no timer exists with this name.");
				return false;
			}
		}
	}
	
	/// @func	timer_execute_early(_name);
	/// @param	{str}	_name	the name of the timer
	timer_execute_early = function(_name) {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].name == _name) {
				_this.timers[int].func();
				array_delete(_this.timers, int, 1);
				return show_debug_message("timer has been executed early and deleted from the list.");
			} else {
				return show_debug_message("no timer exists with this name.");
			}
		}
	}
	
	/// @func	timer_exists(_name);
	/// @param	{str}	_name	the name of the timer
	timer_exists = function(_name) {
		var _timer = timer_get(_name);
		if(is_struct(_timer)) {
			return true;
		} else {
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
			if(place_meeting(x + spd.x, y, _col)) {
				while(!place_meeting(x + sign(spd.x), y, _col)) {
					x += sign(spd.x);
				}
				spd.x = 0;
			}
			if(place_meeting(x, y + spd.y, _col)) {
				while(!place_meeting(x, y + sign(spd.y), _col)) {
					y += sign(spd.y);
				}
				spd.y = 0;
			}
		} // end of with this.owner
	}
	
	/// @func	_bounce(_col);
	/// @param	{obj}	_col	the object collider to check for
	_bounce = function(_col) {
		with(_this.owner) {
			if(place_meeting(x + spd.x, y + spd.y, _col)) {
				spd.x = -spd.x * 0.4;
				spd.y = -spd.y * 0.4;
				input = false;
				other.timer_set(300, "bounce", function() {
					input = true;
				});
			}
		}
	}
	
	/// @func	_slide(_col);
	/// @param	{obj}	_col	the object collider to check for
	_slide = function(_col) {
		with(_this.owner) {
			if(sticking)return false;
			if(place_meeting(x, y, _col)) {
				frict = 0;
				accel = base_accel * 0.5;
				max_spd = base_max_spd;
				sliding = true;
				return true;
			} else {
				max_spd = base_max_spd;
				accel = base_accel;
				frict = base_frict;
				return false;
			}
		}
	}
	
	/// @func	_stick(_col);
	/// @param	{obj}	_col	the object collider to check for
	_stick = function(_col) {
		with(_this.owner) {
			if(sliding)return false;
			if(place_meeting(x, y, _col)) {
				max_spd = base_max_spd * 0.6;
				accel = base_accel * 0.5;
				frict = base_frict;
				sticking = true;
				return true;
			} else {
				max_spd = base_max_spd;
				accel = base_accel;
				frict = base_frict;
				sticking = false;
				return false;
			}
		}
	}
	#endregion
	
	#region /// state change listener functions
	/// @func	is_moving();
	is_moving = function() {
		if(_this.owner.spd.x != 0 || _this.owner.spd.y != 0) {
			return true;
		} else {
			return false;
		}
	}
	
	/// @func	is_colliding(); #IN PROGRESS
	is_colliding = function() {
		return _collide();
	}
	
	/// @func	is_bouncing();
	is_bouncing = function() {
		return timer_exists("bounce");
	}
	
	/// @func	is_sliding();
	is_sliding = function() {
		return _slide();
	}
	
	/// @func	is_sticking();
	is_sticking = function() {
		return _stick();
	}
	
	/// @func	is_dashing();
	is_dashing = function() {
		return timer_exists("dash");
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
	dash = function(x_dir, y_dir) {
		with(_this.owner) {
			spd.x = x_dir * 15;
			spd.y = y_dir * 15;
		}
		set_input_false();
		timer_set(150, "dash", function() {
			with(_this.owner) {
				spd.x = sign(spd.x) * 4;
				spd.y = sign(spd.y) * 4;
			}
			set_input_true();
		});
	}
		
	///	@func	move(x_dir, y_dir);
	///	@param	{int}	x_dir	the x direction of inputs
	/// @param	{int}	y_dir	the y direction of inputs
	move = function(x_dir, y_dir) {
		var move_dir = new Vector2(x_dir, y_dir);
		var point = point_direction(0, 0, move_dir.x, move_dir.y);
		if(_this.owner.input) {
			if(_this.is_complex) {
				if(abs(_this.owner.spd.x) < abs(lengthdir_x(abs(move_dir.x), point) * _this.owner.max_spd)) {
					_this.owner.spd.x += lengthdir_x(abs(move_dir.x) * _this.owner.accel, point) - sign(_this.owner.spd.x) * _this.owner.frict;
				} else {
					_this.owner.spd.x -= sign(_this.owner.spd.x) * _this.owner.frict;
				}
				if(move_dir.x = 0 && abs(_this.owner.spd.x) < 0.1)_this.owner.spd.x = 0;
				
				if(abs(_this.owner.spd.y) < abs(lengthdir_y(abs(move_dir.y), point) * _this.owner.max_spd)) {
					_this.owner.spd.y += lengthdir_y(abs(move_dir.y) * _this.owner.accel, point) - sign(_this.owner.spd.y) * _this.owner.frict;
				} else {
					_this.owner.spd.y -= sign(_this.owner.spd.y) * _this.owner.frict;
				}			
				if(move_dir.y = 0 && abs(_this.owner.spd.y) < 0.1)_this.owner.spd.y = 0;
			} else {
				_this.owner.spd.x = lengthdir_x(abs(move_dir.x), point) * _this.owner.max_spd;
				_this.owner.spd.y = lengthdir_y(abs(move_dir.y), point) * _this.owner.max_spd;
			}
		}
		
		for(var int = 0; int < array_length(_this.colliders); int++) {
			var _col = _this.colliders[int];
			if(_col.collide)_collide(_col.obj);
			if(_col.bounce)_bounce(_col.obj);
			if(_col.slide)_slide(_col.obj);
			if(_col.stick)_stick(_col.obj);
		}
		_this.owner.x += _this.owner.spd.x;
		_this.owner.y += _this.owner.spd.y;
		
		check_timers();
	}
	#endregion
}