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
	
	#region /// timer system #TODO
	add_timer = function() {
		
	}
	
	check_timers = function() {
		
	}
	#endregion
	
	#region // functions for changing base stats after creation
	///	@func	set_accel(_input);
	/// @param	{int}	_input	the number to change accel to
	set_accel = function(_input) {
		_this.owner.accel = _input;
		_this.owner.base_accel = _input;
	};
	
	///	@func	set_frict(_input)
	/// @param	{int}	_input	the number to change frict to
	set_frict = function(_input) {
		_this.owner.frict = _input;
		_this.owner.base_frict = _input;
	};
	
	///	@func	set_max_spd(_input);
	/// @param	{int}	_input	the number to change max_speed to
	set_max_spd = function(_input) {
		_this.owner.max_spd = _input;
		_this.owner.base_max_spd = _input;
	};
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
		}
	}
	
	/// @func	_bounce(_col);
	/// @param	{obj}	_col	the object collider to check for
	_bounce = function(_col) {
		
	}
	
	/// @func	_slide(_col);
	/// @param	{obj}	_col	the object collider to check for
	_slide = function(_col) {
		with(_this.owner) {
			if(is_colliding)return;
			if(place_meeting(x, y, _col)) {
				frict = 0;
				accel = base_accel * 0.5;
				max_spd = base_max_spd;
				is_colliding = true;
			} else {
				max_spd = base_max_spd;
				accel = base_accel;
				frict = base_frict;
			}
		}
	}
	
	/// @func	_stick(_col);
	/// @param	{obj}	_col	the object collider to check for
	_stick = function(_col) {
		with(_this.owner) {
			if(is_colliding)return;
			if(place_meeting(x, y, _col)) {
				max_spd = base_max_spd * 0.6;
				accel = base_accel * 0.5;
				frict = base_frict;
				is_colliding = true;
			} else {
				max_spd = base_max_spd;
				accel = base_accel;
				frict = base_frict;
			}
		}
	}
	#endregion
	
	#region // movement helper functions #TODO
	_dash = function() {
		
	}
		
	///	@func	move(move_dir);
	///	@param	{Vec2}	move_dir	a Vector2 containing the x and y movement inputs
	move = function(x_dir, y_dir) {
		var move_dir = new Vector2(x_dir, y_dir);
		var point = point_direction(0, 0, move_dir.x, move_dir.y);
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
		
		for(var int = 0; int < array_length(_this.colliders); int++) {
			var _col = _this.colliders[int];
			if(_col.collide)_collide(_col.obj);
			if(_col.bounce)_bounce(_col.obj);
			if(_col.slide)_slide(_col.obj);
			if(_col.stick)_stick(_col.obj);
		}
		_this.owner.is_colliding = false;
		_this.owner.x += _this.owner.spd.x;
		_this.owner.y += _this.owner.spd.y;
	}
	#endregion
}

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