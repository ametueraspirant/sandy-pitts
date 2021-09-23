#region // set stats
set_base_stats(3, 0.7, 0.5);
set_combat_stats(5, 1, 1, 1);
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
player = new CombatClass(team.heroes);
player.set_init_helm(o_east_knight_hat);
player.set_init_body(o_east_knight_body);
player.set_init_shield(o_east_knight_shield);
player.set_init_weapon(o_east_knight_weapon);
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
	
	if(input_check_pressed(Verb.lattack, player_num, 5))player.attack(Verb.lattack);
	if(input_check_pressed(Verb.hattack, player_num, 5))player.attack(Verb.hattack);
	if(input_check_pressed(Verb.interact, player_num, 5))player.swap_gear();
})
.event_set_default_function("end_step", function() { 
	player.check(); 
	player.look();
	player.scan_for_items();
})
.event_set_default_function("draw", function() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
	/*if(player.get_gear("helm") != noone)draw_sprite_ext(player.get_gear("helm"), 0, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
	if(player.get_gear("bod") != noone)draw_sprite_ext(player.get_gear("bod"), 0, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);
	if(player.get_gear("shield") != noone)draw_sprite_ext(player.get_gear("shield"), 0, x, y, image_xscale * mv_sign, image_yscale, image_angle, image_blend, image_alpha);*/
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
});
// #ENDTEST
#endregion