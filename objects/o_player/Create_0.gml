#region // set base stats
set_base_stats(5, 0.6, 0.3);
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
cstrat = new CombatStrat();
#endregion

#region // set up state machine
// define new state machine
player = new SnowState("idle");

// define default events
player.event_set_default_function("step", function() {});
player.event_set_default_function("gstep", function() {
	depth = -y;
	var x_dir = input_check(Verb.right) - input_check(Verb.left);
	var y_dir = input_check(Verb.down) - input_check(Verb.up);
	var mv_dir = point_direction(0, 0, x_dir, y_dir);
	var mv_mag = point_distance(0, 0, x_dir, y_dir);
	
	mstrat.move(mv_dir, mv_mag);
	
	var mouse_dir = point_direction(x, y, mouse_x, mouse_y);
	if(mouse_dir > 90 && mouse_dir <= 270)mv_sign = -1;
	else mv_sign = 1;

	if(!instance_exists(curr_weapon))instance_create_layer(x, x, _entity_layer, curr_weapon);
	
	if(mouse_check_button_pressed(mb_left))player.change("attack");
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
		if(!mstrat.timer_exists("attack")) {
			show_debug_message("swoooosh!");
			mstrat.timer_set(1000, "attack", function() {
				player.change("idle");
			});
		} else {
			player.change("idle");
		}
	},
	draw: function() {
		draw_sprite(s_sword_swoosh, 0, x+15, y -1);
	}
});

// define states

#endregion