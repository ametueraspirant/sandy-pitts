#region // set base stats
max_spd = 10;
accel = 1;
frict = 0.5;
#endregion

#region // set up motion strat
// define strat
strat = new TopDownStrat();
#endregion

#region // set up state machine
// define new state machine
player = new SnowState("idle");

// define default events
player.event_set_default_function("step", function() {});
player.event_set_default_function("draw", function() { draw_self() });

// define states

#endregion