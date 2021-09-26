/// @func	CombatClass([_side]);
/// @param	{enum}	[_side]		the team for purposes of ability checks.
function CombatClass(_side) constructor {
	var _owner = other;
	
	_this = {};
	
	with(_this) {
		owner = _owner;
		side = _side;
		attacks = [];
		can_attack = false;
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
		pickup = {
			list: ds_list_create(),
			selection: 0,
			max_select: 3
		}
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
	
	/// @func	enable_attacking();
	enable_attacking = function() {
		_this.can_attack = true;
	}
	
	/// @func	disable_attacking();
	disable_attacking = function() {
		_this.can_attack = false;
	}
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
	
	/// @func	attack_is_enabled();
	attack_is_enabled = function() {
		return _this.can_attack;
	}
	#endregion
	
	#region // i-frame functions #UNFINISHED
	
	#endregion
	
	#region // functions for searching and displaying weapons #UNFINISHED
	/// @func	scan_for_items();
	scan_for_items = function() {
		with(_this) {
			var _wep_list = ds_list_create();
			ds_list_clear(pickup.list);
			
			with(owner)collision_circle_list(x, y, 20, o_item_parent, false, true, _wep_list, true);
			
			var _int = 0;
			repeat(ds_list_size(_wep_list)) {
				var _item = _wep_list[|_int];
				if(_item.gear.state.get_current_state() == "ground") {
					ds_list_add(pickup.list, _item);
				}
				_int++;
			}
			
			if(ds_list_size(pickup.list) == 0)pickup.selection = 0;
			
			ds_list_destroy(_wep_list);
		}
	}
	
	/// @func draw_item_hud();
	draw_item_hud = function() {
		
	}
	#endregion
	
	#region // set init gear functions
	/// @func	set_init_helm(_id);
	/// @param	{id}	_id		gear id input.
	set_init_helm = function(_id) {
		with(_this) {
			if(gear.cur_helm == noone) {
				var _helm = instance_create_layer(owner.x, owner.y, _entity_layer, _id);
				_helm.gear.pick_up(owner.id);
				gear.cur_helm = _helm;
			}
		}
	}
	
	/// @func	set_init_body(_id);
	/// @param	{id}	_id		gear id input.
	set_init_body = function(_id) {
		with(_this) {
			if(gear.cur_bod == noone) {
				var _bod = instance_create_layer(owner.x, owner.y, _entity_layer, _id);
				_bod.gear.pick_up(owner.id);
				gear.cur_bod = _bod;
			}
		}
	}
	
	/// @func	set_init_weapon(_id);
	/// @param	{id}	_id		gear id input.
	set_init_weapon = function(_id) {
		with(_this) {
			if(gear.cur_weapon == noone) {
				var _weapon = instance_create_layer(owner.x, owner.y, _entity_layer, _id);
				_weapon.gear.pick_up(owner.id);
				gear.cur_weapon = _weapon;
				stats = _weapon.attacks.stats;
				list = _weapon.attacks.list;
			}
		}
	}
	
	/// @func	set_init_shield(_id);
	/// @param	{id}	_id		gear id input.
	set_init_shield = function(_id) {
		with(_this) {
			if(gear.cur_shield == noone) {
				var _shield = instance_create_layer(owner.x, owner.y, _entity_layer, _id);
				_shield.gear.pick_up(owner.id);
				gear.cur_shield = _shield;
			}
		}
	}
	#endregion
	
	#region // gear swap management functions #UNFINISHED
	/// @func	get_gear(_type);
	/// @param	{enum}	_type	gear type input.
	get_gear = function(_type) { // #NOTE meant for internal use.
		with(_this) {
			switch(_type) {
				case GEARTYPES.HELM:
				return gear.cur_helm;
				
				case GEARTYPES.BODY:
				return gear.cur_bod;
				
				case GEARTYPES.WEAPON:
				return gear.cur_weapon;
				
				case GEARTYPES.SHIELD:
				return gear.cur_shield;
			}
		}
	}
	
	/// @func	pickup_gear(_id);
	/// @param	{id}	_item		gear input id.
	pickup_gear = function(_item) { // #NOTE meant for internal use.
		with(_this) {
			switch(_item.gear_type) {
				case GEARTYPES.HELM:
				_item.gear.pick_up(owner.id);
				gear.cur_helm = _item;
				break;
				
				case GEARTYPES.BODY:
				_item.gear.pick_up(owner.id);
				gear.cur_bod = _item;
				break;
				
				case GEARTYPES.WEAPON:
				_item.gear.pick_up(owner.id);
				stats = _item.attacks.stats;
				list = _item.attacks.list;
				gear.cur_weapon = _item;
				break;
				
				case GEARTYPES.SHIELD:
				_item.gear.pick_up(owner.id);
				gear.cur_shield = _item;
				break;
			}
		}
	}
	
	/// @func cycle_pickup();
	cycle_pickup = function() {
		with(_this) {
			if(selection < max_select) {
				selection++;
			} else {
				selection = 0;
			}
		}
	}
	
	///	@func	swap_gear();
	swap_gear = function() {
		if(_this.pickup.list != noone) {
			var _item = _this.pickup.list[|_this.pickup.selection];
			switch(_item.gear_type) {
				case GEARTYPES.HELM:
				if(get_gear(GEARTYPES.HELM) != noone)get_gear(GEARTYPES.HELM).gear.drop();
				pickup_gear(_item);
				break;
				
				case GEARTYPES.BODY:
				if(get_gear(GEARTYPES.BODY) != noone)get_gear(GEARTYPES.BODY).gear.drop();
				pickup_gear(_item);
				break;
				
				case GEARTYPES.WEAPON:
				if(get_gear(GEARTYPES.WEAPON) != noone)get_gear(GEARTYPES.WEAPON).gear.drop();
				pickup_gear(_item);
				break;
				
				case GEARTYPES.SHIELD:
				if(get_gear(GEARTYPES.SHIELD) != noone)get_gear(GEARTYPES.SHIELD).gear.drop();
				pickup_gear(_item);
				break;
			}
		}
	}
	
	/// @func	drop_gear(_type);
	/// @param	{type}	_type	the type of gear to drop.
	drop_gear = function(_type) {
		switch(_type) {
			case GEARTYPES.HELM:
			if(get_gear(GEARTYPES.HELM) != noone) {
				get_gear(GEARTYPES.HELM).gear.drop();
				_this.gear.cur_helm = noone;
			}
			break;
			
			case GEARTYPES.BODY:
			if(get_gear(GEARTYPES.BODY) != noone) {
				get_gear(GEARTYPES.BODY).gear.drop();
				_this.gear.cur_bod = noone;
			}
			break;
			
			case GEARTYPES.WEAPON:
			if(get_gear(GEARTYPES.WEAPON) != noone) {
				get_gear(GEARTYPES.WEAPON).gear.drop();
				_this.gear.cur_weapon = noone;
				_this.stats = noone;
				_this.attacks = noone;
				disable_attacking();
			}
			break;
			
			case GEARTYPES.SHIELD:
			if(get_gear(GEARTYPES.SHIELD) != noone) {
				get_gear(GEARTYPES.SHIELD).gear.drop();
				_this.gear.cur_shield = noone;
			}
			break;
		}
	}
	#endregion
	
	#region // attacking functions #UNFINISHED
	/// @func	start(_seq);
	/// @param	{sequence}	_seq	the input sequence
	start = function(_seq) {
		with(_this) {
			if(gear.cur_weapon != noone) {
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
					
					other.get_gear(GEARTYPES.WEAPON).gear.disable();
				});
			}
		}
	}
	
	/// @func	check();
	check = function() {
		with(_this) {
			other.timer.check();
			
			if(seq._cur == noone)return;
			
			var _att = list[attack_index];
			var _frame = layer_sequence_get_headpos(seq._cur);
			
			layer_sequence_angle(seq._cur, owner.look_dir);
			layer_sequence_x(seq._cur, owner.x);
			layer_sequence_y(seq._cur, owner.y);
			layer_depth(seq._layer, owner.depth - 10);
			
			if(_frame >= _att.attack_frame && _frame < _att.attack_frame + 1) {
				other.look_dir_lock();
			}
			
			if(_frame >= _att.reset_frame && _frame < _att.reset_frame + 1) {
				other.look_dir_unlock();
				attacking = false;
			}
			
			if(_att.type == ACTIONTYPE.HELD) {
				// add aiming line that extends with hold time.
				if(_frame >= _att.hold_frame && _frame < _att.hold_frame + 1) {
					if(input_check(Verb.hattack)) {
						layer_sequence_pause(seq._cur);
					} else {
						layer_sequence_play(seq._cur);
					}
				}
			}
			
			if(_att.type == ACTIONTYPE.CHARGE) {
				// add charge vibration scaling up with charge time.
				if(_frame >= _att.charge_min && _frame < _att.charge_min + 1) {
					layer_sequence_headpos(seq._cur, _att.charge_end);
				}
				if(_frame >= _att.charge_end && _frame < _att.charge_end + 1) {
					
				}
			}
			
			if(layer_sequence_is_finished(seq._cur)) {
				layer_sequence_pause(seq._cur);
				other.timer.set(stats.reset_time, "reset_time", function() {
					layer_sequence_destroy(seq._cur);
					layer_destroy(seq._layer);
					
					seq._attack = noone;
					seq._layer = noone;
					seq._cur = noone;
					attack_index = 0;
					other.get_gear(GEARTYPES.WEAPON).gear.enable();
				});
			}
		}
	}
	
	/// @func	attack(_input);
	/// @param	{enum}	_input	takes in a verb enum for light or heavy.
	attack = function(_input) {
		if(!is_attacking()) {
			if(timer.exists("reset_time"))timer.cancel("reset_time");
			with(_this) {
				if(seq._cur != noone) {
					layer_sequence_destroy(seq._cur);
					layer_destroy(seq._layer);
					
					seq._attack = noone;
					seq._layer = noone;
					seq._cur = noone;
					other.get_gear(GEARTYPES.WEAPON).gear.enable();
				}
				
				if(_input == Verb.lattack && list[attack_index].link_light != noone) {
					attack_index = list[attack_index].link_light;
					other.start(list[attack_index].action);
				} else if(_input = Verb.hattack && list[attack_index].link_heavy != noone) {
					attack_index = list[attack_index].link_heavy;
					other.start(list[attack_index].action);
				}
				
			}
		}
	}
	#endregion
	
	#region // player step event, please call this and not check, look, or scan_for_items.
	/// @func	step();
	step = function() {
		check();
		look();
		scan_for_items();
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