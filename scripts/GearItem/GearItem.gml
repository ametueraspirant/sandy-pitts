/// @func Gear(_struct);
function Gear(_wielder, _follow_angle = 0, _x_displace = 0, _y_displace = 0, _z_displace = 0) constructor {
	var _owner = other.id;
	
	_this = {};
	
	with(_this) {
		owner = _owner;
		wielder = _wielder;
		follow_angle = _follow_angle;
		x_displace = _x_displace;
		y_displace = _y_displace;
		z_displace = _z_displace;
	}
	
	#region // state machine
	state = new SnowState("dropped");
	
	state
	.event_set_default_function("step", function() {
		with(_this) {
			if(wielder != noone) {
				if(wielder.player.is_attacking()) {
					owner.x = wielder.x + x_displace;
					owner.y = wielder.y + y_displace;
					owner.depth = -owner.y - z_displace;
					owner.image_angle = wielder.look_dir + follow_angle;
				}
			}
		}
	})
	.event_set_default_function("draw", function() {
		if(instance_exists(_this.wielder) && !_this.wielder.player.is_attacking())draw_self();
	})
	#endregion
}

/// @func Item(_struct);
function Item() constructor {
	
}