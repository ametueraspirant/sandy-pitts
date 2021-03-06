/// @param centerX
/// @param centerY
/// @param radius
/// @param [playerIndex]

function input_cursor_limit_circle(_centre_x, _centre_y, _radius, _player_index = 0)
{
    if (INPUT_WARNING_DEPRECATED) __input_error("This function has been deprecated\n(Set INPUT_WARNING_DEPRECATED to <false> to ignore this warning)");
    
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
    
    with(global.__input_players[_player_index].cursor)
    {
        limit_l = undefined;
        limit_t = undefined;
        limit_r = undefined;
        limit_b = undefined;
        
        limit_x = _centre_x;
        limit_y = _centre_y;
        limit_radius = _radius;
        
        limit();
    }
}