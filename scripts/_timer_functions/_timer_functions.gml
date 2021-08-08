function timer_system() constructor {
	var _owner = other.id;
	
	_this = {};
	
	with(_this) {
		timers = [];
		
	}
	/// @func	get(_name);
	/// @param	{any}	_name	the name of the timer
	get = function(_name) {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].name == _name) {
				return [_this.timers[int], int];
			}
		}
		return false;
	}
	
	/// @func	set(_dur, _name, _func);
	/// @param	{int}	_dur	the duration of the timer to set
	/// @param	{any}	_name	the name of the timer
	/// @param	{func}	_func	the function to run when the timer runs out
	set = function(_dur, _name, _func) {
		if(!is_array(timer_get(_name)))array_push(_this.timers, new timer(_dur, _name, _func));
		return true;
	}
	
	/// @func	execute(_name);
	/// @param	{any}	_name	the name of the timer
	execute = function(_name) {
		var _timer = timer_get(_name);
		if(is_array(_timer)) {
			_timer[0].func();
			array_delete(_this.timers, _timer[1], 1);
			show_debug_message("timer has been executed early and deleted from the list.");
			return true;
		} else {
			show_debug_message("no timer exists with this name.");
			return false;
		}
	}
	
	/// @func	exists(_name);
	/// @param	{any}	_name	the name of the timer
	exists = function(_name) {
		var _timer = timer_get(_name);
		if(is_array(_timer)) {
			return true;
		} else {
			return false;
		}
	}
	
	/// @func	time(_name);
	/// @param	{any}	_name	the name of the timer
	time = function(_name) {
		var _timer = timer_get(_name);
		if(is_array(_timer)) {
			return _timer[0].time + _timer[0].dur - current_time;
		} else {
			show_debug_message("no timer exists with this name.");
			return false;
		}
	}
	
	/// @func	check();
	check = function() {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].time + _this.timers[int].dur <= current_time) {
				_this.timers[int].func();
				array_delete(_this.timers, int, 1);
			}
		}
	}
}

/// @func	timer(_dur, _func);
/// @param	{int}	_dur	the duration of the timer in frames
/// @param	{str}	_name	the name of the timer
/// @aparam	{func}	_func	the function to run when the timer duration runs out
function timer(_dur, _name, _func) constructor {
	time = current_time;
	name = _name;
	dur = _dur;
	func = _func;
}