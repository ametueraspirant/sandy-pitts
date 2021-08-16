input_tick();
var _input = input_source_detect_any();
if(_input.source != INPUT_SOURCE.NONE) {
	input_player_source_set(_input.source);
	if(_input.source == INPUT_SOURCE.GAMEPAD) {
		input_player_gamepad_set(_input.gamepad);
	}
}