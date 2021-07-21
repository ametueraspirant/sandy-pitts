/// @func TopDownStrat(colliders, [is_complex], [accel], [frict])
/// @param	{obj}	colliders			the colliders this object collides with
/// @param	{bool}	[is_complex]		whether to use simple or complex movement
/// @param	{int}	[accel]				accel to use if movement is complex
/// @param	{int}	[frict]				frict to use if movement is complex
function TopDownStrat(_colliders) constructor {
	var _is_complex = (argument_count > 1) ? argument[1] : true;
	var _accel = (argument_count > 2) ? argument[2] : sprite_width * 0.1;
	var _frict = (argument_count > 3) ? argument[3] : sprite_width * 0.05;
	var _max_spd = (argument_count > 4) ? argument[4] : floor(sprite_width * 0.5);
	var _owner = other;
	
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
	
	set_accel = function(_input) {
		_this.accel = _input;
	};
	
	set_frict = function(_input) {
		_this.frict = _input;
	};
	
	set_max_spd = function(_input) {
		_this.max_spd = _input;
	};
	
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
		
		for(col = 0; col < array_length(_this.colliders); col++) {
			
		}
		
		_this.owner.x += _this.spd.x;
		_this.owner.y += _this.spd.y;
	};
	
	
}