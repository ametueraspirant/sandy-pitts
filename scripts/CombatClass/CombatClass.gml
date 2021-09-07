/// @func	CombatClass([_side]);
/// @param	{enum}	[_side]		the team for purposes of ability checks.
function CombatClass(_side) constructor {
	var _owner = other;
	
	_this = {};
	
	with(_this) {
		owner = _owner;
		side = _side;
		attacks = [];
		gear = { cur_helm: noone, cur_bod: noone, cur_weapon: noone, cur_shield: noone };
		items = [];
		seq = {
			_attack: noone,
			_layer: noone,
			_cur: noone
		}
		attacking = false;
		attack_index = 0;
		stats = noone;
		list = noone;
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
		_this.owner.cur_hp = clamp(_this.owner.cur_hp + _hp, 0, _this.owner.max_hp);
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
	/// @func	set_gear(_type, _id);
	///	@param	{string}	_type	gear type input.
	/// @param	{id}		_id		gear id input.
	set_gear = function(_type, _id) {
		with(_this) {
			switch(_type) {
				case "helm":
				gear.cur_helm = _id;
				break;
				
				case "bod":
				gear.cur_bod = _id;
				break;
				
				case "weapon":
				if(gear.cur_weapon != noone) {
					with(gear.cur_weapon)instance_destroy(); // #TEST probably remove later with weapon swapping.
				}
				var _weapon = instance_create_layer(owner.x, owner.y, _entity_layer, _id);
				_weapon.owner = owner.id;
				gear.cur_weapon = _weapon;
				stats = _weapon.attacks.stats;
				list = _weapon.attacks.list;
				break;
				
				case "shield":
				gear.cur_shield = _id;
				break;
			}
		}
	}
	
	/// @func	get_gear(_type);
	/// @param	{string}	_type	gear type input.
	get_gear = function(_type) {
		with(_this) {
			switch(_type) {
				case "helm":
				return gear.cur_helm;
				
				case "bod":
				return gear.cur_bod;
				
				case "weapon":
				return gear.cur_weapon;
				
				case "shield":
				return gear.cur_shield;
			}
		}
	}
	
	///	@func	swap_gear(_id);
	/// @param	{id}	_id	gear id input.
	swap_gear = function(_id) {
		
	}
	#endregion
	
	#region // attacking functions
	/// @func	start(_seq);
	/// @param	{sequence}	_seq	the input sequence
	start = function(_seq) {
		with(_this) {
			attacking = true;
			seq._attack = _seq;
			seq._layer = layer_create(owner.depth);
			seq._cur = layer_sequence_create(seq._layer, owner.x, owner.y, seq._attack);
			
			other.timer.set(1, "set attack", function() {
				layer_sequence_angle(seq._cur, owner.look_dir);
				layer_sequence_speedscale(seq._cur, 0.9 + owner.act_spd * 0.1);
				layer_sequence_xscale(seq._cur, 0.9 + owner.size * 0.1);
				layer_sequence_yscale(seq._cur, 0.9 + owner.size * 0.1);
				
				var _box = instance_create_layer(-1000, -1000, seq._layer, o_hitbox);
				_box.damage = owner.damage;
				_box.side = side;
				_box.image_angle = owner.look_dir;
				sequence_instance_override_object(layer_sequence_get_instance(seq._cur), o_hitbox, _box);
			});
		}
	}
	
	/// @func	check();
	check = function() {
		with(_this) {
			other.timer.check();
			
			if(seq._cur == noone)return;
			
			var _att = list[attack_index]
			
			layer_sequence_angle(seq._cur, owner.look_dir);
			layer_sequence_x(seq._cur, owner.x);
			layer_sequence_y(seq._cur, owner.y);
			layer_depth(seq._layer, owner.depth - 10);
			
			if(layer_sequence_get_headpos(seq._cur) == _att.attack_frame) {
				other.look_dir_lock();
			}
			
			if(layer_sequence_get_headpos(seq._cur) == _att.reset_frame) {
				other.look_dir_unlock();
			}
			
			if(_att.type == ACTIONTYPE.HELD) {
				// add aiming line that extends with hold time.
				if(layer_sequence_get_headpos(seq._cur) == _att.hold_frame) {
					if(input_check(Verb.hattack)) {
						layer_sequence_pause(seq._cur);
					} else {
						layer_sequence_play(seq._cur);
					}
				}
			}
			
			if(_att.type == ACTIONTYPE.CHARGE) {
				// add charge vibration scaling up with charge time.
				if(layer_sequence_get_headpos(seq._cur) == _att.charge_min) {
					layer_sequence_headpos(seq._cur, _att.charge_end);
				}
				if(layer_sequence_get_headpos(seq._cur) == _att.charge_end) {
					
				}
			}
			
			if(layer_sequence_is_finished(seq._cur)) {
				layer_sequence_pause(seq._cur);
				if(!other.timer.exists("end_lag") && !other.timer.exists("reset_time")) {
					other.timer.set(stats.end_lag, "end_lag", function() {
						
						other.timer.set(stats.reset_time, "reset_time", function() {
							layer_sequence_destroy(seq._cur);
							layer_destroy(seq._layer);
							
							seq._attack = noone;
							seq._layer = noone;
							seq._cur = noone;
							attack_index = 0;
							attacking = false;
						});
					});
				}
			}
		}
	}
	
	/// @func	attack(_input);
	/// @param	{enum}	_input	takes in a verb enum for light or heavy.
	attack = function(_input) {
		if(timer.exists("reset_time")) {
			timer.cancel("reset_time");
			with(_this) {
				layer_sequence_destroy(seq._cur);
				layer_destroy(seq._layer);
				
				seq._attack = noone;
				seq._layer = noone;
				seq._cur = noone;
				
				var _att = other.get_gear("weapon").attacks.list;
				if(_input == Verb.lattack && _att[attack_index].link_light != noone) {
					attack_index = _att[attack_index].link_light;
					other.start(_att[attack_index].action);
				} else if(_input == Verb.hattack && _att[attack_index].link_heavy != noone) {
					attack_index = _att[attack_index].link_heavy;
					other.start(_att[attack_index].action);
				}
			}
		}
		if(!is_attacking() && !timer.exists("end_lag")) {
			with(_this) {
				var _att = other.get_gear("weapon").attacks.list;
				if(_input == Verb.lattack && _att[attack_index].link_light != noone) {
					attack_index = _att[attack_index].link_light;
					other.start(_att[attack_index].action);
				} else if(_input == Verb.hattack && _att[attack_index].link_heavy != noone) {
					attack_index = _att[attack_index].link_heavy;
					other.start(_att[attack_index].action);
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