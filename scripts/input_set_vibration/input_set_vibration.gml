function input_set_vibration(_left_motor, _right_motor, _player_index = 0)
{
	var _gamepad = input_player_gamepad_get(_player_index);
	if(_gamepad == INPUT_NO_GAMEPAD)return undefined;
	
	if (_player_index < 0)
	{
		__input_error("Invalid player index provided (", _player_index, ")");
		return undefined;
	}
	
	if (_player_index >= INPUT_MAX_PLAYERS)
	{
		__input_error("Player index too large (", _player_index, " vs. ", INPUT_MAX_PLAYERS, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
		return undefined;
	}
	
	if(_left_motor > 1 || _left_motor < 0)
	{
		__input_error("Invalid left motor value: ", _left_motor, ". must be between 0 and 1.");
		return undefined;
	}
	
	if(_right_motor > 1 || _right_motor < 0)
	{
		__input_error("Invalid right motor value: ", _right_motor, ". must be between 0 and 1.");
		return undefined;
	}
	
	gamepad_set_vibration(_gamepad, _left_motor, _right_motor);
}