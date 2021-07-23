#region // set base stats
max_spd = 5;
accel = 0.6;
frict = 0.3;
move_dir = new Vector2(0, 0);
#endregion

#region // set up motion strat
// define strat
strat = new TopDownStrat(true, accel, frict, max_spd);
strat.add_collider([o_wall, o_obstacle_test], );
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
	strat.move(move_dir);
});
player.event_set_default_function("draw", function() { draw_self() });

player.add("idle", {
	step: function() {
		
	}
});

// define states

#endregion