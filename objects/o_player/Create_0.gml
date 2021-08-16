#region // set stats
set_base_stats(5, 0.6, 0.3);
set_combat_stats(5, 1, 1, 1);
curr_helm = s_heavy_helm;
curr_bod = s_heavy_bod;
curr_weapon = o_sword;
mv_sign = 1;
look_dir = 0;
look_dir_saved = 0;
#endregion

#region // set up motion strat
// define motion strat
mstrat = new TopDownStrat();
mstrat.add_collider(o_wall, "collide");
mstrat.add_collider(o_obstacle_test, "collide");
//mstrat.add_collider(o_floor, "slide");

#endregion

#region // set up combat strat
class = new CombatClass();
#endregion

#region // set up timer
timer = new TimerSystem();
#endregion

#region // set up state machine
// define new state machine
player = new SnowState("idle");

// define default events
player.event_set_default_function("step", function() {});
player.event_set_default_function("gstep", function() {
	depth = -bbox_bottom;
	
	timer.check();
	class.acheck();
	
	var mv_dir = input_direction(Verb.move_left,	Verb.move_right, Verb.move_up, Verb.move_down);
	if(mv_dir == undefined)mv_dir = 0;
	var mv_mag = input_distance(Verb.move_left,	Verb.move_right, Verb.move_up, Verb.move_down);
	if(mv_mag == undefined)mv_mag = 0;
	
	mstrat.move(mv_dir, mv_mag);
	
	// #TEST pretty much all of this is going to be replaced with something better.
	
	if(input_player_source_get(0) == INPUT_SOURCE.KEYBOARD_AND_MOUSE)look_dir = point_direction(x, y, mouse_x, mouse_y);
	else if(input_player_source_get(0) == INPUT_SOURCE.GAMEPAD) look_dir = input_direction(Verb.aim_left, Verb.aim_right, Verb.aim_up, Verb.aim_down);
	
	if(look_dir == undefined)look_dir = look_dir_saved;
	look_dir_saved = look_dir;
	
	if(look_dir > 90 && look_dir <= 270)mv_sign = -1;
	else mv_sign = 1;

	if(!instance_exists(curr_weapon))instance_create_layer(x, x, _entity_layer, curr_weapon); // #TEST
	
	if(input_check_pressed(Verb.attack) && player.get_current_state() != "attack")player.change("attack"); // #TODO flesh out attack system
	
	if(input_check_pressed(Verb.swap_complex))mstrat.is_complex_toggle(); // #TEST
});
player.event_set_default_function("draw", function() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
	if(curr_helm != noone)draw_sprite_ext(curr_helm, 0, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
	if(curr_bod != noone)draw_sprite_ext(curr_bod, 0, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
});

// idle state
player.add("idle", {
	enter: function() {
		sprite_index = s_player_idle;
		image_index = 0;
		image_speed = 0;
	},
	step: function() {
		if(mstrat.is_moving())player.change("moving");
	}
});

// moving state
player.add("moving", {
	enter: function() {
		sprite_index = s_player_run;
	},
	step: function() {
		var mv_spd = point_distance(0, 0, spd.x, spd.y) + 1;
		image_speed = ((mv_spd + 1) / max_spd) * sign(mv_sign * spd.x + 1); // I don't know why this works but it does so DON'T TOUCH IT.
		if(!mstrat.is_moving())player.change("idle");
	}
});

// attack state
player.add("attack", {
	enter: function() {
		if(!timer.exists("attack")) {
			show_debug_message("swoooosh!");
			class.attack(q_sword_1);
			timer.set(1000, "attack", function() {
				player.change("idle");
			});
		} else {
			player.change("idle");
		}
	},
});
#endregion