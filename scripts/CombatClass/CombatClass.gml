/// @func	CombatClass();
function CombatClass(_side) constructor {
	var _owner = other;
	
	_this = {};
	
	with(_this) {
		owner = _owner;
		side = _side;
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
	
		/// @func	look_dir_lock();
	look_dir_lock = function() {
		_this.owner.look_dir_locked = true;
	}
	
	///	@func	look_dir_unlock();
	look_dir_unlock = function() {
		_this.owner.look_dir_locked = false;
	}
	#endregion
	
	#region // gear changing functions #UNFINISHED
	
	#endregion
	
	#region // attacking functions
	/// @func	start(_seq);
	/// @param	{sequence}	_seq	the input sequence
	start = function(_seq) {
		with(_this) {
			attacking = true;
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
				_box.side = side;
				_box.image_angle = owner.look_dir;
				sequence_instance_override_object(layer_sequence_get_instance(cur_seq), o_hitbox, _box);
			});
		}
	}
	
	/// @func	check();
	check = function() {
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
	
	/// @func	attack(_input);
	/// @param	{enum}	_input	takes in a verb enum for light or heavy.
	attack = function(_input) {
		if(!is_attacking()) {
			with(_this) {
				var _att = owner.gear.cur_weapon.attacks;
				if(_input == Verb.lattack && _att.list[attack_index].link_light != noone) {
					attack_index = _att.list[attack_index].link_light;
					other.start(_att.list[attack_index].act);
				} else if(_input == Verb.hattack && _att.list[attack_index].link_heavy != noone) {
					attack_index = _att.list[attack_index].link_heavy;
					other.start(_att.list[attack_index].act);
				}
			}
		}
	}
	#endregion
	
	#region // i-frame functions #UNFINISHED
	
	#endregion
	
	#region // state change listener functions
	/// @func	is_attacking();
	is_attacking = function() {
		return _this.attacking;
	}
	
	/// @func	look_dir_is_locked();
	look_dir_is_locked = function() {
		return _this.owner.look_dir_locked;
	}
	#endregion
	
	#region // functions for controlling look direction and angle
	/// @func look();
	look = function() {
		with(_this.owner) {
			if(!other.look_dir_is_locked()) {
				if(input_player_source_get(player_num) == INPUT_SOURCE.KEYBOARD_AND_MOUSE)look_dir = point_direction(x, y, mouse_x, mouse_y);
				else if(input_player_source_get(player_num) == INPUT_SOURCE.GAMEPAD)look_dir = input_direction(Verb.aim_left, Verb.aim_right, Verb.aim_up, Verb.aim_down, player_num);
			}
			
			if(look_dir == undefined)look_dir = look_dir_saved;
			look_dir_saved = look_dir;
			
			if(look_dir > 90 && look_dir <= 270)mv_sign = -1;
			else mv_sign = 1;
		}
	}
	#endregion
}

#region // combat handler functions
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
		mv_sign = 1;
		look_dir = 0;
		look_dir_saved = 0;
		look_dir_locked = false;
	}
}

function AttackList(_struct) constructor {
	#region // instantate variables
	stats = _struct.stats;
	
	if(!variable_struct_exists(stats, "end_lag"))stats.end_lag = 0;
	if(!variable_struct_exists(stats, "reset_time"))stats.reset_time = 0;
	
	if(!variable_struct_exists(stats, "light_start"))stats.light_start = noone;
	if(!variable_struct_exists(stats, "heavy_start"))stats.heavy_start = noone;
	#endregion
	
	#region // create list with an extra object at array 0 that contains an empty attack with only link variables.
	list = [];
	
	array_push(list, new Attack({ act: noone,	
								  link_light: stats.light_start,
								  link_heavy: stats.heavy_start,
								  cancel_threshold: 0,
								  rotation_lock_threshold: 0,
								  rotation_unlock_threshold: 0,
								  charge_time: 0,
								  charge_min: 0,
								  damage_multi: 1 }));
	
	var _i = 0;
	repeat(array_length(_struct.list)) {
		array_push(list, _struct.list[_i]);
		_i++;
	}
	#endregion
	
	#region // loop through the list, converting link sequences to the index of that sequence in the array.
	var _i = 0;
	repeat(array_length(list)) {
		if(list[_i].link_light != noone) {					//	make sure that link_light isn't noone.
			var _l = 0;
			repeat(array_length(list)) {
				if(list[_l].act == list[_i].link_light) {	//	check to see if the current index contains the sequence in the link_light reference.
					list[_i].link_light = _l;				//	set link_light to equal the index of the attack sequence that matches.
					break;
				}
				_l++;
			}
		}
		
		if(list[_i].link_heavy != noone) {					//	make sure that link_heavy isn't noone.
			var _h = 0;
			repeat(array_length(list)) {
				if(list[_h].act == list[_i].link_heavy) {	//	check to see if the current index contains the sequence in the link_heavy reference.
					list[_i].link_heavy = _h;				//	set link_heavy to equal the index of the attack sequence that matches.
					break;
				}
				_h++;
			}
		}
		_i++;
	}
	#endregion
}

function Attack(_struct) constructor {
	type = "attack";
	
	#region // check that act exists and is a sequence and set it.
	if(!variable_struct_exists(_struct, "act")) {
		act = noone;
	} else if(_struct.act == noone) {
		act = _struct.act;
	} else if(!sequence_exists(_struct.act)) {
		show_debug_message("act must be a sequence or 'noone.' setting to 'noone.'");
		act = noone;
	} else {
		act = _struct.act;
	}
	#endregion
	
	#region // check that link_light exists and is a sequence and set it.
	if(!variable_struct_exists(_struct, "link_light")) {
		link_light = noone;
	} else if(_struct.link_light == noone) {
		link_light = _struct.link_light;
	} else if(!sequence_exists(_struct.link_light)) {
		show_debug_message("link_light must be a valid sequence or 'noone.' setting to 'noone.'");
		link_light = noone;
	} else {
		link_light = _struct.link_light;
	}
	#endregion
	
	#region // check that link_heavy exists and is a sequence and set it.
	if(!variable_struct_exists(_struct, "link_heavy")) {
		link_heavy = noone;
	} else if(_struct.link_heavy == noone) {
		link_heavy = _struct.link_heavy;
	} else if(!sequence_exists(_struct.link_heavy)) {
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
	
	#region // check that charge_min exists and is a real positive integer and set it.
	if(!variable_struct_exists(_struct, "charge_min")) {
		charge_min = 0;
	} else if(!is_real(_struct.charge_min)) {
		show_debug_message("charge_min must be real. setting to 0.");
		charge_min = 0;
	} else if(frac(_struct.charge_min) != 0) {
		show_debug_message("charge_min must be an integer. rounding down.");
		cancel_treshold = int64(_struct.charge_min);
	} else if(_struct.charge_min < 0) {
		show_debug_message("charge_min must be positive. setting to 0.");
		charge_min = 0;
	} else {
		charge_min = _struct.charge_min;
	}
	#endregion
	
	#region // check that damage_multi exists and is a real number that is 1 or greater and set it.
	if(!variable_struct_exists(_struct, "damage_multi")) {
		damage_multi = 1;
	} else if(!is_real(_struct.damage_multi)) {
		show_debug_message("damage_multi must be real. setting to 1.");
		damage_multi = 1;
	} else if(_struct.damage_multi < 1) {
		show_debug_message("damage_multi must be more than 1. setting to 1.");
		damage_multi = 1;
	} else {
		damage_multi = _struct.damage_multi;
	}
	#endregion
}

function Skill(_struct) constructor {
	type = "skill";
	
	
}
#endregion