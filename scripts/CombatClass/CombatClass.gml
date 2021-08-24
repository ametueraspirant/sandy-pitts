/// @func	CombatClass();
function CombatClass() constructor {
	var _owner = other;
	
	_this = {};
	
	with(_this) {
		owner = _owner;
		attacks = [];
		gear = { cur_helm: noone, cur_bod: noone, cur_weapon: noone, cur_shield: noone };
		items = [];
		cur_attack = noone;
		attack_index = 0;
		cur_layer = noone;
		cur_seq = noone;
		attacking = false;
	}
	
	if(!_this.owner.has_combat_stats) {
		show_debug_message("you haven't set your stats up. consider using the set_combat_stats function to initialize all of the stats this object will use.");
	}
	
	#region /// timer system
	timer = new TimerSystem();
	#endregion
	
	#region // functions for changing base stats after creation
	/// @func	hp_set(_hp);
	/// @param	{int}	_hp		the hp value to add or subtract.
	hp_set = function(_hp) {
		_this.owner.hp = clamp(_this.owner.hp + _hp, 0, _this.owner.max_hp);
	}
	
	/// @func	hp_set_max(_max_hp);
	/// @param	{int}	_max_hp		the max_hp value to set
	hp_set_max = function(_max_hp) {
		_this.owner.max_hp = _max_hp;
	}
	
	/// @func	damage_set(_damage);
	/// @param	{int}	_damage		the damage value to set
	damage_set = function(_damage) {
		_this.owner.dam = _damage;
	}
	#endregion
	
	#region // gear changing functions
	
	#endregion
	
	#region // attacking functions
	/// @func	attack(_seq);
	/// @param	{sequence}	_seq	the input sequence
	attack = function(_seq) {
		with(_this) {
			cur_attack = _seq;
			cur_layer = layer_create(owner.depth);
			cur_seq = layer_sequence_create(cur_layer, owner.x, owner.y, cur_attack);
			
			other.timer.set(1, "set attack", function() {
				layer_sequence_angle(cur_seq, owner.look_dir);
				layer_sequence_speedscale(cur_seq, 0.9 + owner.act_spd * 0.1);
				layer_sequence_xscale(cur_seq, 0.9 + owner.size * 0.1);
				layer_sequence_yscale(cur_seq, 0.9 + owner.size * 0.1);
				
				var _box = instance_create_layer(-1000, -1000, cur_layer, o_hitbox);
				_box.damage = owner.damage;
				_box.image_angle = owner.look_dir;
				sequence_instance_override_object(layer_sequence_get_instance(cur_seq), o_hitbox, _box);
				
				attacking = true;
			});
		}
	}
	
	/// @func	acheck();
	acheck = function() {
		with(_this) {
			if(cur_seq == noone)return;
			
			layer_sequence_angle(cur_seq, owner.look_dir);
			layer_sequence_x(cur_seq, owner.x);
			layer_sequence_y(cur_seq, owner.y);
			layer_depth(cur_layer, owner.depth - 10);
			
			other.timer.check();
			
			if(layer_sequence_is_finished(cur_seq)) {
				layer_sequence_destroy(cur_seq);
				layer_destroy(cur_layer);
				
				cur_attack = noone;
				cur_layer = noone;
				cur_seq = noone;
				attacking = false;
			}
		}
	}
	#endregion
	
	#region // i-frame functions
	
	#endregion
	
	#region // state change listener functions
	/// @func	is_attacking();
	is_attacking = function() {
		return _this.attacking;
	}
	#endregion
}

/// @func	set_combat_stats(_hp, _dam, _act_spd, _size);
/// @param	{int}	_hp			hitpoints
/// @param	{int}	_dam		attack damage
/// @param	{int}	_act_spd	action speed
/// @param	{int}	_size		player size
function set_combat_stats(_hp, _dam, _act_spd, _size) {
	with(other) {
		has_combat_stats = true;
		cur_hp = _hp;
		max_hp = _hp;
		damage = _dam;
		act_spd = _act_spd;
		size = _size;
	}
}

function AttackList(_struct) constructor {
	
}

function Attack(_struct) constructor {
	#region // check that act exists and is a sequence and set it.
	if(!variable_struct_exists(_struct, "act")) {
		show_debug_message("attacks require an act variable. make sure act exists and is a valid sequence id.");
		act = "error";
	} else if(!sequence_exists(_struct.act)) {
		show_debug_message("act must be a sequence. make sure act is a valid sequence id.");
		act = "error";
	} else {
		act = _struct.act;
	}
	#endregion
	
	#region // check that link_light exists and is a sequence and set it.
	if(!variable_struct_exists(_struct, "link_light")) {
		link_light = noone;
	} else if(sequence_exists(_struct.link_light)) {
		show_debug_message("link_light must be a valid sequence or 'noone.' setting to 'noone.'");
		link_light = noone;
	} else {
		link_light = _struct.link_light;
	}
	#endregion
	
	#region // check that link_heavy exists and is a sequence and set it.
	if(!variable_struct_exists(_struct, "link_heavy")) {
		link_heavy = noone;
	} else if(sequence_exists(_struct.link_heavy)) {
		show_debug_message("link_heavy must be a valid sequence or 'noone.' setting to 'noone.'");
		link_heavy = noone;
	} else {
		link_heavy = _struct.link_heavy;
	}
	#endregion
	
	#region // check that cancel_threshold exists and is a real positive integer and set it.
	if(!variable_struct_exists(_struct, "cancel_threshold")) {
		cancel_threshold = 0;
	} else if(!is_real(_struct.cancel_threshold)) {
		show_debug_message("cancel_threshold must be real. setting to 0.");
		cancel_threshold = 0;
	} else if(frac(_struct.cancel_threshold) != 0) {
		show_debug_message("cancel_threshold must be an integer. rounding down.");
		cancel_treshold = int64(_struct.cancel_threshold);
	} else if(_struct.cancel_threshold < 0) {
		show_debug_message("cancel_threshold must be positive. setting to 0.");
		cancel_threshold = 0;
	} else {
		cancel_threshold = _struct.cancel_threshold;
	}
	#endregion
	
	#region// check that rotation_lock_threshold exists and is a real positive integer and set it.
	if(!variable_struct_exists(_struct, "rotation_lock_threshold")) {
		rotation_lock_threshold = 0;
	} else if(!is_real(_struct.rotation_lock_threshold)) {
		show_debug_message("rotation_lock_threshold must be real. setting to 0.");
		rotation_lock_threshold = 0;
	} else if(frac(_struct.rotation_lock_threshold) != 0) {
		show_debug_message("rotation_lock_threshold must be an integer. rounding down.");
		cancel_treshold = int64(_struct.rotation_lock_threshold);
	} else if(_struct.rotation_lock_threshold < 0) {
		show_debug_message("rotation_lock_threshold must be positive. setting to 0.");
		rotation_lock_threshold = 0;
	} else {
		rotation_lock_threshold = _struct.rotation_lock_threshold;
	}
	#endregion
	
	#region // check that rotation_unlock_threshold exists and is a real positive integer and set it.
	if(!variable_struct_exists(_struct, "rotation_unlock_threshold")) {
		rotation_unlock_threshold = 0;
	} else if(!is_real(_struct.rotation_unlock_threshold)) {
		show_debug_message("rotation_unlock_threshold must be real. setting to 0.");
		rotation_unlock_threshold = 0;
	} else if(frac(_struct.rotation_unlock_threshold) != 0) {
		show_debug_message("rotation_unlock_threshold must be an integer. rounding down.");
		cancel_treshold = int64(_struct.rotation_unlock_threshold);
	} else if(_struct.rotation_unlock_threshold < 0) {
		show_debug_message("rotation_unlock_threshold must be positive. setting to 0.");
		rotation_unlock_threshold = 0;
	} else {
		rotation_unlock_threshold = _struct.rotation_unlock_threshold;
	}
	#endregion
	
	#region // check that charge_time exists and is a real positive integer and set it.
	if(!variable_struct_exists(_struct, "charge_time")) {
		charge_time = 0;
	} else if(!is_real(_struct.charge_time)) {
		show_debug_message("charge_time must be real. setting to 0.");
		charge_time = 0;
	} else if(frac(_struct.charge_time) != 0) {
		show_debug_message("charge_time must be an integer. rounding down.");
		cancel_treshold = int64(_struct.charge_time);
	} else if(_struct.charge_time < 0) {
		show_debug_message("charge_time must be positive. setting to 0.");
		charge_time = 0;
	} else {
		charge_time = _struct.charge_time;
	}
	#endregion
}

function Skill(_struct) constructor {
	
}