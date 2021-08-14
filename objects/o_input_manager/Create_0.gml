enum Verb {
	up,
	down,
	left,
	right,
	attack,
	defend,
	esc,
	f2,
	f3,
	ctrl
}

#region // input keys
// input default keys
input_default_key(vk_up, Verb.up);
input_default_key(vk_down, Verb.down);
input_default_key(vk_left, Verb.left);
input_default_key(vk_right, Verb.right);
input_default_key(ord("J"), Verb.attack);
input_default_key(ord("k"), Verb.defend);
input_default_key(vk_escape, Verb.esc);
input_default_key(vk_f2, Verb.f2);
input_default_key(vk_f3, Verb.f3);

// input alternate keys
input_default_key(ord("W"), Verb.up, 1);
input_default_key(ord("S"), Verb.down, 1);
input_default_key(ord("A"), Verb.left, 1);
input_default_key(ord("D"), Verb.right, 1);
input_default_key(ord("Z"), Verb.attack, 1);
input_default_key(ord("X"), Verb.defend, 1);

// input player source
input_player_source_set(INPUT_SOURCE.KEYBOARD_AND_MOUSE);
#endregion