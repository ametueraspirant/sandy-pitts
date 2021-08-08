function timer_init_system(_target) {
	with(_target) {
		if(has_timer_system) {
			show_debug_message("there is already a timer system set up on this object.");
			return;
		} else {
			timers = [];
			has_timer_system = true;
		}
	}
}

/// @func	timer_get(_name);
/// @param	{str}	_name	the name of the timer
function timer_get(_name) {
	for(var int = 0; int < array_length(_this.timers); int++) {
		if(_this.timers[int].name == _name) {
			return [_this.timers[int], int];
		}
	}
	return false;
}

/// @func	timer_set(_dur, _func);
/// @param	{int}	_dur	the duration of the timer to set
/// @param	{str}	_name	the name of the timer
/// @param	{func}	_func	the function to run when the timer runs out
function timer_set(_dur, _name, _func) {
	if(!is_array(timer_get(_name)))array_push(_this.timers, new timer(_dur, _name, _func));
	return true;
}

/// @func	timer_execute_early(_name);
/// @param	{str}	_name	the name of the timer
function timer_execute_early(_name) {
	var _timer = timer_get(_name);
	if(is_array(_timer)) {
		_timer[0].func();
		array_delete(_this.timers, _timer[1], 1);
		show_debug_message("timer has been executed early and deleted from the list.");
		return true;
	} else {
		show_debug_message("no timer exists with this name.");
		return false;
	};
}

/// @func	timer_exists(_name);
/// @param	{str}	_name	the name of the timer
function timer_exists(_name) {
	var _timer = timer_get(_name);
	if(is_array(_timer)) {
		return true;
	} else {
		return false;
	}
}

/// @func	timer_get_remaining_time(_name);
/// @param	{str}	_name	the name of the timer
function timer_get_remaining_time(_name) {
	var _timer = timer_get(_name);
	if(is_array(_timer)) {
		return _timer[0].time + _timer[0].dur - current_time;
	} else {
		show_debug_message("no timer exists with this name.");
		return false;
	}
}
	
/// @func	check_timers();
function check_timers() {
	for(var int = 0; int < array_length(_this.timers); int++) {
		if(_this.timers[int].time + _this.timers[int].dur <= current_time) {
			_this.timers[int].func();
			array_delete(_this.timers, int, 1);
		}
	}
}