#region // set stats
set_base_stats(3, 0.7, 0.5);
set_combat_stats(5, 1, 1, 1);
gear = {
	cur_helm: s_east_knight_hat,
	cur_bod: s_east_knight_body,
	cur_shield: s_east_knight_shield,
	cur_weapon: o_east_knight_weapon
}
player_num = 0;
#endregion

#region // set up motion strat
// define motion strat
mstrat = new TopDownStrat();
//mstrat.add_collider(o_wall, "collide");
//mstrat.add_collider(o_obstacle_test, "collide");
//mstrat.add_collider(o_floor, "slide");

#endregion

#region // set up combat strat
player = new CombatClass();
#endregion

#region // set up timer
timer = new TimerSystem();
#endregion

#region // set up state machine
// define new state machine
state = new SnowState("idle");

// #TEST pretty much all of this is going to be replaced with something better.
// define default events
state
.event_set_default_function("step", function() {})
.event_set_default_function("g_step", function() {
	depth = -bbox_bottom;
	
	timer.check();
	
	var mv_dir = input_direction(Verb.move_left, Verb.move_right, Verb.move_up, Verb.move_down, player_num);
	if(mv_dir == undefined)mv_dir = 0;
	var mv_mag = input_distance(Verb.move_left,	Verb.move_right, Verb.move_up, Verb.move_down, player_num);
	if(mv_mag == undefined)mv_mag = 0;
	
	mstrat.move(mv_dir, mv_mag);
	
	player.look();
	
	if(input_check_pressed(Verb.lattack, player_num) && state.get_current_state() != "attack")state.change("attack"); // #TODO flesh out attack system using add_child(); and inherit();
})
.event_set_default_function("end_step", function() { player.acheck(); })
.event_set_default_function("draw", function() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
	if(gear.cur_helm != noone)draw_sprite_ext(gear.cur_helm, 0, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
	if(gear.cur_bod != noone)draw_sprite_ext(gear.cur_bod, 0, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
	if(gear.cur_shield != noone)draw_sprite_ext(gear.cur_shield, 0, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
})

// define states
.add("idle", {
	enter: function() {
		sprite_index = s_player_idle;
		image_index = 0;
		image_speed = 0;
	},
	step: function() {
		if(mstrat.is_moving())state.change("moving");
	}
})
.add("moving", {
	enter: function() {
		sprite_index = s_player_run;
	},
	step: function() {
		var mv_spd = point_distance(0, 0, spd.x, spd.y) + 1;
		image_speed = ((mv_spd + 1) / max_spd) * sign(mv_sign * spd.x + 1); // I don't know why this works but it does so DON'T TOUCH IT.
		if(!mstrat.is_moving())state.change("idle");
	}
})
.add("attack", {
	enter: function() {
		if(!timer.exists("attack")) {
			show_debug_message("swoooosh!");
			player.attack(Verb.lattack);
			timer.set(1000, "attack", function() {
				state.change("idle");
			});
		} else {
			state.change("idle");
		}
	},
});
// #ENDTEST
#endregion