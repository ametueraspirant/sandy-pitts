/// @func	TopDownStrat(colliders, [is_complex], [accel], [frict])
/// @param	{obj}	colliders			the colliders this object collides with
/// @param	{bool}	[is_complex]		whether to use simple or complex movement
/// @param	{int}	[accel]				accel to use if movement is complex
/// @param	{int}	[frict]				frict to use if movement is complex
function TopDownStrat(_colliders) constructor {
	var _is_complex = (argument_count > 1) ? argument[1] : true;
	var _accel = (argument_count > 2) ? argument[2] : sprite_width * 0.1;
	var _frict = (argument_count > 3) ? argument[3] : sprite_width * 0.05;
	var _max_spd = (argument_count > 4) ? argument[4] : floor(sprite_width * 0.5);
	var _owner = other.id;
	
	_this = {};
	
	with(_this) {
		is_complex = _is_complex;
		owner = _owner;
		accel =_accel;
		frict =_frict;
		colliders = (is_array(_colliders)) ? _colliders : [_colliders];
		max_spd = _max_spd;
		spd = new Vector2(0, 0);
	}
	
	///	@func	set_acel(_input);
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
	
	///	@func	add_collider(_coll);
	/// @param	{arr}	_coll	an object or array of objects desired to add to the colliders list
	add_collider = function(_coll) {
		var arr = (is_array(_coll)) ? _coll : [_coll];
		for(int = 0; int < array_length(arr); int++) {
			array_push(_this.colliders, arr[int]);
		}
	};
	
	///	@func	delete_collider(_coll);
	/// @param	{arr}	_coll	an object or array of objects desired to delete from the colliders list
	delete_collider = function(_coll) {
		var arr = (is_array(_coll)) ? _coll : [_coll];
		for(var c = 0; c < array_length(arr); c++) {
			for(var int = 0; int < array_length(_this.colliders); int++) {
				if(arr[c] == _this.colliders[int]) {
					array_delete(_this.colliders, int, 1);
				}
			}
		}
	}
	
	///	@func	move_and_slide(move_dir);
	///	@param	{Vec2}	move_dir	a Vector2 containing the x and y movement inputs
	move_and_slide = function(move_dir) {
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