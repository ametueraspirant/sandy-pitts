#region // set stats
set_base_stats(5, 0.6, 0.3);
set_combat_stats(5, 1, 1, 1);
curr_helm = s_heavy_helm;
curr_bod = s_heavy_bod;
curr_weapon = o_sword;
mv_sign = 1;
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
	depth = -y;
	
	timer.check();
	class.acheck();
	
	//var x_dir = input_value(Verb.right) - input_value(Verb.left);
	//var y_dir = input_value(Verb.down) - input_value(Verb.up);
	//var mv_dir = point_direction(0, 0, x_dir, y_dir); input_direction
	//var mv_mag = point_distance(0, 0, x_dir, y_dir);
	var mv_dir = input_direction(input_value(Verb.left),
								input_value(Verb.right),
								input_value(Verb.up),
								input_value(Verb.down));
	if(mv_dir == undefined)mv_dir = 0;
	var mv_mag = input_distance(input_value(Verb.left),
								input_value(Verb.right),
								input_value(Verb.up),
								input_value(Verb.down));
	if(mv_mag == undefined)mv_mag = 0;
	
	mstrat.move(mv_dir, mv_mag);
	
	var mouse_dir = point_direction(x, y, mouse_x, mouse_y);
	if(mouse_dir > 90 && mouse_dir <= 270)mv_sign = -1;
	else mv_sign = 1;

	if(!instance_exists(curr_weapon))instance_create_layer(x, x, _entity_layer, curr_weapon);
	
	if(mouse_check_button_pressed(mb_left) && player.get_current_state() != "attack")player.change("attack");
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
		image_speed = ((mv_spd + 1) / max_spd) * sign(mv_sign * spd.x + 1); // I don't know why this works but it does.
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