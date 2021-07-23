#region // set base stats
set_base_stats(self, 100, 10, 5, 0.6, 0.3);
move_dir = new Vector2(0, 0);
#endregion

#region // set up motion strat
// define motion strat
mstrat = new TopDownStrat(true);
mstrat.add_collider([o_wall, o_obstacle_test], true, false, true, true);
#endregion

#region // set up state machine
// define new state machine
player = new SnowState("idle");

// define default events
player.event_set_default_function("step", function() {});
player.event_set_default_function("gstep", function() {
	depth = -y;
	move_dir.x = input_check(Verb.right) - input_check(Verb.left);
	move_dir.y = input_check(Verb.down) - input_check(Verb.up);
	mstrat.move(move_dir);
	mstrat.check_timers();
});
player.event_set_default_function("draw", function() { draw_self() });

player.add("idle", {
	step: function() {
		
	}
});

// define states

#endregion