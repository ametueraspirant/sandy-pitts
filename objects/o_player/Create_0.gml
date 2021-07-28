#region // set base stats
set_base_stats(100, 10, 5, 0.6, 0.3);
#endregion

#region // set up motion strat
// define motion strat
mstrat = new TopDownStrat();
mstrat.add_collider(o_wall, "collide");
mstrat.add_collider(o_obstacle_test, "collide");
//mstrat.add_collider(o_floor, "slide");

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
	
	if(!instance_exists(o_spear))instance_create_layer(x, x, _entity_layer, o_spear);
});
player.event_set_default_function("draw", function() {
	draw_self();
	draw_sprite(s_heavy_helm, 0, x, y);
	draw_sprite(s_heavy_bod, 0, x, y);
});

player.add("idle", {
	step: function() {
		
	}
});

// define states

#endregion