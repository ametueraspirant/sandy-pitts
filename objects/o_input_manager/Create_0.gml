enum Verb {
	up, down, left, right,
	dash, attack, defend,
	menu, swap_complex
}

#region // set default inputs
// set default keyboard inputs
input_default_key(ord("W"), Verb.up);
input_default_key(ord("S"), Verb.down);
input_default_key(ord("A"), Verb.left);
input_default_key(ord("D"), Verb.right);
input_default_key(vk_space, Verb.dash);
input_default_mouse_button(mb_left, Verb.attack);
input_default_mouse_button(mb_right, Verb.defend);
input_default_key(vk_escape, Verb.menu);
input_default_key(vk_lcontrol, Verb.swap_complex); // #TEST

// set default controller inputs
input_default_gamepad_axis(gp_axislv, 1, Verb.up);
input_default_gamepad_axis(gp_axislv, 0, Verb.down);
input_default_gamepad_axis(gp_axislh, 1, Verb.left);
input_default_gamepad_axis(gp_axislh, 0, Verb.right);
input_default_gamepad_button(gp_face2, Verb.dash);
input_default_gamepad_button(gp_face1, Verb.attack);
input_default_gamepad_button(gp_shoulderr, Verb.defend);
input_default_gamepad_button(gp_start, Verb.menu);
input_default_gamepad_button(gp_select, Verb.swap_complex); // #TEST

// input player source
//input_player_source_set(INPUT_SOURCE.KEYBOARD_AND_MOUSE);
#endregion