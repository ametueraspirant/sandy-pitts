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

/// @func	AttackList(_struct);
/// @param	{struct}	_struct		the input struct.
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
	
	array_push(list, new Attack({ type: noone,
								  action: noone,	
								  link_light: stats.light_start,
								  link_heavy: stats.heavy_start,
								  attack_frame: 0,
								  reset_frame: 0,
								  damage_multi: 0 }));
	
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
				if(list[_l].action == list[_i].link_light) {	//	check to see if the current index contains the sequence in the link_light reference.
					list[_i].link_light = _l;				//	set link_light to equal the index of the attack sequence that matches.
					break;
				}
				_l++;
			}
		}
		
		if(list[_i].link_heavy != noone) {					//	make sure that link_heavy isn't noone.
			var _h = 0;
			repeat(array_length(list)) {
				if(list[_h].action == list[_i].link_heavy) {	//	check to see if the current index contains the sequence in the link_heavy reference.
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

/// @func	Attack(_struct);
/// @param	{struct}	_struct		the input struct.
function Attack(_struct) constructor {
	#region // check and set input type.
	if(!variable_struct_exists(_struct, "type")) {
		show_debug_message("variable type does not exist or is misnamed. setting type to INSTANT.");
		type = ACTIONTYPE.INSTANT;
	} else {
		switch(_struct.type) {
			case ACTIONTYPE.INSTANT:
			type = ACTIONTYPE.INSTANT;
			break;
			
			case ACTIONTYPE.HELD:
			type = ACTIONTYPE.HELD;
			break;
			
			case ACTIONTYPE.CHARGE:
			type = ACTIONTYPE.CHARGE;
			break;
			
			default:
			show_debug_message("type must use the ACTIONTYPE enum. setting to INSTANT.");
			type = ACTIONTYPE.INSTANT;
			break;
		}
	}
	#endregion
	
	#region // check that action exists and is a sequence and set it.
	if(!variable_struct_exists(_struct, "action")) {
		action = noone;
	} else if(_struct.action == noone) {
		action = _struct.action;
	} else if(!sequence_exists(_struct.action)) {
		show_debug_message("action must be a sequence or 'noone.' setting to 'noone.'");
		action = noone;
	} else {
		action = _struct.action;
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
	
	#region// check that attack_frame exists and is a real positive integer and set it.
	if(!variable_struct_exists(_struct, "attack_frame")) {
		attack_frame = 0;
	} else if(!is_real(_struct.attack_frame)) {
		show_debug_message("attack_frame must be real. setting to 0.");
		attack_frame = 0;
	} else if(frac(_struct.attack_frame) != 0) {
		show_debug_message("attack_frame must be an integer. rounding down.");
		attack_frame = int64(_struct.attack_frame);
	} else if(_struct.attack_frame < 0) {
		show_debug_message("attack_frame must be positive. setting to 0.");
		attack_frame = 0;
	} else {
		attack_frame = _struct.attack_frame;
	}
	#endregion
	
	#region // check that reset_frame exists and is a real positive integer and set it.
	if(!variable_struct_exists(_struct, "reset_frame")) {
		reset_frame = 0;
	} else if(!is_real(_struct.reset_frame)) {
		show_debug_message("reset_frame must be real. setting to 0.");
		reset_frame = 0;
	} else if(frac(_struct.reset_frame) != 0) {
		show_debug_message("reset_frame must be an integer. rounding down.");
		reset_frame = int64(_struct.reset_frame);
	} else if(_struct.reset_frame < 0) {
		show_debug_message("reset_frame must be positive. setting to 0.");
		reset_frame = 0;
	} else {
		reset_frame = _struct.reset_frame;
	}
	#endregion
	
	#region // check that damage_multi exists and is a real positive integer and set it.
	if(!variable_struct_exists(_struct, "damage_multi")) {
		damage_multi = 0;
	} else if(!is_real(_struct.damage_multi)) {
		show_debug_message("damage_multi must be real. setting to 1.");
		damage_multi = 1;
	} else if(_struct.damage_multi < 0) {
		show_debug_message("damage_multi must be positive. setting to 1.");
		damage_multi = 1;
	} else {
		damage_multi = _struct.damage_multi;
	}
	#endregion
	
	#region // check that attack_type = CHARGE, that charge_min exists, and that it is a real positive integer, then set it.
	if(variable_struct_exists(_struct, "type") && _struct.type == ACTIONTYPE.CHARGE) {
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
	}
	#endregion
	
	#region // check that attack_type = CHARGE, that charge_end exists, and that it is a real positive integer, then set it.
	if(variable_struct_exists(_struct, "type") && _struct.type == ACTIONTYPE.CHARGE) {
		if(!variable_struct_exists(_struct, "charge_end")) {
			charge_end = 0;
		} else if(!is_real(_struct.charge_end)) {
			show_debug_message("charge_end must be real. setting to 0.");
			charge_end = 0;
		} else if(frac(_struct.charge_end) != 0) {
			show_debug_message("charge_end must be an integer. rounding down.");
			charge_end = int64(_struct.charge_end);
		} else if(_struct.charge_end < 0) {
			show_debug_message("charge_end must be positive. setting to 0.");
			charge_end = 0;
		} else {
			charge_end = _struct.charge_end;
		}
	}
	#endregion
	
	#region // check that attack_type = HELD, that hold_frame exists, and that it is a real positive integer, then set it.
	if(variable_struct_exists(_struct, "type") && _struct.type == ACTIONTYPE.CHARGE) {
		if(!variable_struct_exists(_struct, "hold_frame")) {
			hold_frame = 0;
		} else if(!is_real(_struct.hold_frame)) {
			show_debug_message("hold_frame must be real. setting to 0.");
			hold_frame = 0;
		} else if(frac(_struct.hold_frame) != 0) {
			show_debug_message("hold_frame must be an integer. rounding down.");
			cancel_treshold = int64(_struct.hold_frame);
		} else if(_struct.hold_frame < 0) {
			show_debug_message("hold_frame must be positive. setting to 0.");
			hold_frame = 0;
		} else {
			hold_frame = _struct.hold_frame;
		}
	}
	#endregion
}

/// @func	Skill(_struct);
/// @param	{struct}	_struct		the input struct.
function Skill(_struct) constructor {
	#region // check and set input type.
	if(!variable_struct_exists(_struct, "type")) {
		show_debug_message("variable type does not exist or is misnamed. setting type to INSTANT.");
		type = ACTIONTYPE.INSTANT;
	} else {
		switch(_struct.type) {
			case ACTIONTYPE.INSTANT:
			type = ACTIONTYPE.INSTANT;
			break;
			
			case ACTIONTYPE.HELD:
			type = ACTIONTYPE.HELD;
			break;
			
			case ACTIONTYPE.CHARGE:
			type = ACTIONTYPE.CHARGE;
			break;
			
			default:
			show_debug_message("type must use the ACTIONTYPE enum. setting to INSTANT.");
			type = ACTIONTYPE.INSTANT;
			break;
		}
	}
	#endregion
	
	
}

enum ACTIONTYPE {
  INSTANT,
  HELD,
  CHARGE
}