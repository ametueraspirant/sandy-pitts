function rebind_gamepad_tick() {
    var _input = input_source_detect_any();
	if(_input.source != INPUT_SOURCE.NONE) {
		for(var int = 0; int < INPUT_MAX_PLAYERS; int++) {
			if(!input_player_connected(int)) {
			    input_player_source_set(_input.source);
			    if(_input.source == INPUT_SOURCE.GAMEPAD) {
					input_player_gamepad_set(_input.gamepad);
				}
				show_debug_message("player " + string(_input.gamepad) + " connected to slot " + string(int));
				return;
			}
		}
	}
}