enum Verb {
	move_up, move_down, move_left, move_right,
	aim_up, aim_down, aim_left, aim_right,
	dash, lattack, hattack, defend,
	menu, swap_complex
}

#region // set default keyboard inputs
input_default_key(ord("W"), Verb.move_up);
input_default_key(ord("S"), Verb.move_down);
input_default_key(ord("A"), Verb.move_left);
input_default_key(ord("D"), Verb.move_right);
input_default_key(vk_space, Verb.dash);
input_default_mouse_button(mb_left, Verb.lattack);
input_default_mouse_button(mb_side1, Verb.hattack); // #TEST
input_default_mouse_button(mb_right, Verb.defend);
input_default_key(vk_escape, Verb.menu);
#endregion

#region // set default controller inputs
input_default_gamepad_axis(gp_axislv, 1, Verb.move_up);
input_default_gamepad_axis(gp_axislv, 0, Verb.move_down);
input_default_gamepad_axis(gp_axislh, 1, Verb.move_left);
input_default_gamepad_axis(gp_axislh, 0, Verb.move_right);
input_default_gamepad_axis(gp_axisrv, 1, Verb.aim_up);
input_default_gamepad_axis(gp_axisrv, 0, Verb.aim_down);
input_default_gamepad_axis(gp_axisrh, 1, Verb.aim_left);
input_default_gamepad_axis(gp_axisrh, 0, Verb.aim_right);
input_default_gamepad_button(gp_face2, Verb.dash);
input_default_gamepad_button(gp_shoulderrb, Verb.lattack);
input_default_gamepad_button(gp_shoulderlb, Verb.hattack);
input_default_gamepad_button(gp_shoulderr, Verb.defend);
input_default_gamepad_button(gp_start, Verb.menu);
#endregion

#region // input player source
input_player_source_set(INPUT_SOURCE.KEYBOARD_AND_MOUSE);
#endregion

#region // set up state machine
state = new SnowState("listening");

state
.event_set_default_function("begin_step", function() { input_tick(); })
.event_set_default_function("step", function() { rebind_gamepad_tick(); })
.add("listening", { // default input mode. new inputs will be slotted to the lowest slot available, and disconnected players will attempt to be reconnected to their respective slot.
	step: function() {
		input_assignment_tick(1, 4, -1, false);
	}
})
.add("rebinding", { // the input rebinding mode. automatically clears any filled player slots and ask them to press a button to join that slot.
	enter: function() {
		rebind_all_players();
		global.players = [];
	},
	step: function() {
		input_assignment_tick(1, 4, -1, false);
	}
});
#endregion