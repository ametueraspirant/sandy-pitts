enum Verb {
	kb_up, kb_down, kb_left, kb_right,
	gp_lr, gp_ud,
	dash, attack, defend,
	menu, unbind
}

#region // set default inputs
// set default keyboard inputs
input_default_key(ord("W"), Verb.kb_up);
input_default_key(ord("S"), Verb.kb_down);
input_default_key(ord("A"), Verb.kb_left);
input_default_key(ord("D"), Verb.kb_right);
input_default_key(vk_space, Verb.dash);
input_default_mouse_button(mb_left, Verb.attack);
input_default_mouse_button(mb_right, Verb.defend);
input_default_key(vk_escape, Verb.menu);
input_default_key(vk_lcontrol, Verb.unbind);

// set default controller inputs
input_default_gamepad_axis(gp_axislh, 1, Verb.gp_lr);
input_default_gamepad_axis(gp_axislv, 1, Verb.gp_ud);
input_default_gamepad_button(gp_face2, Verb.dash);
input_default_gamepad_button(gp_face1, Verb.attack);
input_default_gamepad_button(gp_shoulderr, Verb.defend);
input_default_gamepad_button(gp_start, Verb.menu);
input_default_gamepad_button(gp_select, Verb.unbind);

// input player source
input_player_source_set(INPUT_SOURCE.KEYBOARD_AND_MOUSE, 0);
input_player_source_set(INPUT_SOURCE.GAMEPAD, 1);
#endregion