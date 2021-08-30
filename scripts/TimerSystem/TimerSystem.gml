function TimerSystem() constructor {
	var _owner = other;
	
	_this = {};
	
	with(_this) {
		owner = _owner;
		timers = [];
		name = "__timersystem__";
	}
	
	/// @func	get(_name);
	/// @param	{any}	_name	the name of the timer
	get = function(_name) {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].name == _name) {
				return _this.timers[int];
			}
		}
		return undefined;
	}
	
	/// @func	index(_name);
	/// @param	{any}	_name	the name of the timer
	index = function(_name) {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].name == _name) {
				return int;
			}
		}
		return undefined;
	}
	
	/// @func	set(_dur, _name, _func);
	/// @param	{int}	_dur	the duration of the timer to set
	/// @param	{any}	_name	the name of the timer
	/// @param	{func}	_func	the function to run when the timer runs out
	set = function(_dur, _name, _func) {
		if(index(_name) == undefined)array_push(_this.timers, new __timer(_dur, _name, _func));
		return true;
	}
	
	/// @func	execute(_name);
	/// @param	{any}	_name	the name of the timer
	execute = function(_name) {
		var _i = index(_name);
		if(_i != undefined) {
			_this.timers[_i].func();
			array_delete(_this.timers, _i, 1);
			show_debug_message("timer has been executed early and deleted from the list.");
			return true;
		} else {
			show_debug_message("no timer exists with this name.");
			return false;
		}
	}
	
	/// @func	cancel(_name);
	/// @param	{any}	_name	the name of the timer
	cancel = function(_name) {
		var _i = index(_name);
		if(_i != undefined) {
			array_delete(_this.timers, _i, 1);
			show_debug_message("timer has been cancelled, it will not execute.");
			return true;
		} else {
			show_debug_message("no timer exists with this name.");
			return false;
		}
	}
	
	/// @func	exists(_name);
	/// @param	{any}	_name	the name of the timer
	exists = function(_name) {
		var _i = index(_name);
		if(_i != undefined) {
			return true;
		} else {
			return false;
		}
	}
	
	/// @func	time(_name);
	/// @param	{any}	_name	the name of the timer
	time = function(_name) {
		var _t = get(_name);
		if(_t != undefined) {
			return _t.time + _t.dur - current_time;
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

/// @func	__timer(_dur, _func);
/// @param	{int}	_dur	the duration of the timer in frames
/// @param	{str}	_name	the name of the timer
/// @aparam	{func}	_func	the function to run when the timer duration runs out
function __timer(_dur, _name, _func) constructor {
	time = current_time;
	name = _name;
	dur = _dur;
	func = _func;
}