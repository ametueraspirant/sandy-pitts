input_tick();
var _input = input_source_detect_any();
if(_input.source != INPUT_SOURCE.NONE) { // #TODO replace this with proper hotswap logic and put it in game controller probably.
	input_player_source_set(_input.source, 1);
	input_player_gamepad_set(_input.gamepad, 1);
}