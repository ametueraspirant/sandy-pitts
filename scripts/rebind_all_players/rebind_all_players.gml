function rebind_all_players() {
    for(var int = 0; int < INPUT_MAX_PLAYERS; int++) {
        input_player_source_set(INPUT_SOURCE.NONE, int);
    }
}