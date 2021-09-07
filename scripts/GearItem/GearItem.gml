/// @func Gear(_struct);
function GearItem(_wielder, _follow_angle = 0, _x_displace = 0, _y_displace = 0, _z_displace = 0) constructor {
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
	
	#region // timer system
	timer = new TimerSystem();
	#endregion
	
	#region // base variable alter functions
	/// @func	set_wielder(_wielder);
	/// @param	{id}	_wielder	the current holder of the weapon. noone for dropped.
	set_wielder = function(_wielder) {
		_this.wielder = _wielder;
	}
	
	/// @func	set_follow_angle(_angle);
	/// @param	{int}	_angle	the angle to follow at. default 0.
	set_follow_angle = function(_angle) {
		_this.follow_angle = _angle;
	}
	
	/// @func	set_x_displace(_displace);
	/// @param	{int}	_displace	the x displace value to set. default 0.
	set_x_displace = function(_displace) {
		_this.x_displace = _displace;
	}
	
	/// @func	set_y_displace(_displace);
	/// @param	{int}	_displace	the y displace value to set. default 0.
	set_y_displace = function(_displace) {
		_this.y_displace = _displace;
	}
	
	/// @func	set_z_displace(_displace);
	/// @param	{int}	_displace	the z displace value to set. default 0.
	set_z_displace = function(_displace) {
		_this.z_displace = _displace;
	}
	#endregion
	
	#region // state machine
	state = new SnowState("ground");
	
	state
	.event_set_default_function("end_step", function() {})
	.event_set_default_function("draw", function() {
		if(instance_exists(_this.wielder) && !_this.wielder.player.is_attacking())draw_self();
	})
	
	// ground state. weapon drops to ground if moving from other states.
	.add("ground", {
		
	})
	.add("follow", {
		end_step: function() {
			with(_this) {
				if(wielder != noone) {
					owner.x = wielder.x + x_displace;
					owner.y = wielder.y + y_displace;
					owner.depth = -owner.y - z_displace;
					owner.image_angle = wielder.look_dir + follow_angle;
				}
			}
		}
	})
	.add("follow_locked", {
		end_step: function() {
			with(_this) {
				if(wielder != noone) {
					owner.x = wielder.x + x_displace;
					owner.y = wielder.y + y_displace;
					owner.depth = -owner.y - z_displace;
				}
			}
		}
	})
	.add("backpack", {
		enter: function() { //TODO add enter code if needed
			
		},
		end_step: function() {
			with(_this) {
				if(wielder != noone) {
					owner.x = wielder.x + x_displace;
					owner.y = wielder.y + y_displace;
					owner.depth = -owner.y - z_displace;
				}
			}
		},
		draw: function() {}
	});
	#endregion
}

enum GEARTYPES {
	WEAPON,
	ARMOR,
	ITEM,
	SKILL
}