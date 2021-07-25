#region // set base stats
set_base_stats(100, 10, 5, 0.6, 0.3);
#endregion

#region // set up motion strat
// define motion strat
mstrat = new TopDownStrat(true);
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
	mstrat.move(x_dir, y_dir);
});
player.event_set_default_function("draw", function() { draw_self() });

player.add("idle", {
	step: function() {
		
	}
});

// define states

#endregion