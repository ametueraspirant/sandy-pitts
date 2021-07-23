/// @func	TopDownStrat(colliders, [is_complex], [accel], [frict])
/// @param	{obj}	colliders			the colliders this object collides with
/// @param	{bool}	[is_complex]		whether to use simple or complex movement
/// @param	{int}	[accel]				accel to use if movement is complex
/// @param	{int}	[frict]				frict to use if movement is complex
function TopDownStrat() constructor {
	var _is_complex = (argument_count > 0) ? argument[0] : true;
	var _accel = (argument_count > 1) ? argument[1] : sprite_width * 0.1;
	var _frict = (argument_count > 2) ? argument[2] : sprite_width * 0.05;
	var _max_spd = (argument_count > 3) ? argument[3] : floor(sprite_width * 0.5);
	var _owner = other.id;
	
	_this = {};
	
	with(_this) {
		is_complex = _is_complex;
		owner = _owner;
		accel =_accel;
		frict =_frict;
		colliders = [];
		max_spd = _max_spd;
		spd = new Vector2(0, 0);
	}
	
	#region // functions for changing base stats after creation
	///	@func	set_accel(_input);
	/// @param	{int}	_input	the number to change accel to
	set_accel = function(_input) {
		_this.accel = _input;
	};
	
	///	@func	set_frict(_input)
	/// @param	{int}	_input	the number to change frict to
	set_frict = function(_input) {
		_this.frict = _input;
	};
	
	///	@func	set_max_spd(_input);
	/// @param	{int}	_input	the number to change max_speed to
	set_max_spd = function(_input) {
		_this.max_spd = _input;
	};
	#endregion
	
	#region // functions for modifying colliders
	/// @func add_collider();
	add_collider = function() {
		
	}
	
	/// @func delete_collider
	delete_collider = function() {
		
	}
	
	/// @func modify_collider();
	modify_collider = function() {
		
	}
	#endregion
	
	#region /// #Internal Functions, Not meant to be called externally
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
	
	///	@func	move(move_dir);
	///	@param	{Vec2}	move_dir	a Vector2 containing the x and y movement inputs
	move = function(move_dir) {
		var point = point_direction(0, 0, move_dir.x, move_dir.y);
		if(_this.is_complex) {
			if(abs(_this.spd.x) < _this.max_spd) {
				_this.spd.x += lengthdir_x(abs(move_dir.x) * _this.accel, point) - sign(_this.spd.x) * _this.frict;
			} else {
				_this.spd.x -= sign(_this.spd.x) * _this.frict;
			}
			if(move_dir.x = 0 && abs(_this.spd.x) < 0.1)_this.spd.x = 0;
			
			if(abs(_this.spd.y) < _this.max_spd) {
				_this.spd.y += lengthdir_y(abs(move_dir.y) * _this.accel, point) - sign(_this.spd.y) * _this.frict;
			} else {
				_this.spd.y -= sign(_this.spd.y) * _this.frict;
			}			
			if(move_dir.y = 0 && abs(_this.spd.y) < 0.1)_this.spd.y = 0;
			
		} else {
			_this.spd.x = lengthdir_x(abs(move_dir.x), point) * _this.max_spd;
			_this.spd.y = lengthdir_y(abs(move_dir.y), point) * _this.max_spd;
		}
		with(_this.owner) {
			var ths = other._this;
			for(col = 0; col < array_length(ths.colliders); col++) {
				if(place_meeting(x + ths.spd.x, y, ths.colliders[col])) {
					while(!place_meeting(x + sign(ths.spd.x), y, ths.colliders[col])) {
						x += sign(ths.spd.x);
					}
					ths.spd.x = 0;
				}
				
				if(place_meeting(x, y + ths.spd.y, ths.colliders[col])) {
					while(!place_meeting(x, y + sign(ths.spd.y), ths.colliders[col])) {
						y += sign(ths.spd.y);
					}
					ths.spd.y = 0;
				}
			}
			
			
		}
		_this.owner.x += _this.spd.x;
		_this.owner.y += _this.spd.y;
	};
	
	
}

/// @func	new collider(_obj, _collide, _bounce, _slide, _stick);
/// @param	{obj}	the collider object
/// @param	{bool}	whether it is solid
/// @param	{bool}	whether it is bouncy
/// @param	{bool}	whether it will slide
/// @param	{bool}	whether it is sticky
function collider(_obj, _collide, _bounce, _slide, _stick) constructor {
	obj = _obj;
	collide = _collide;
	bounce = _bounce;
	slide = _slide;
	stick = _stick;
}