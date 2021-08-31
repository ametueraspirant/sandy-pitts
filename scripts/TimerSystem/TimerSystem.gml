/// @author	Amet
/// @func	TimerSystem();
/// @param	{int}	[_default_type]	default timer input type. defaults to milliseconds.
function TimerSystem(_default_type = TIMER_DEFAULT_SETTING) constructor {
	var _owner = other;
	
	_this = {};
	
	with(_this) {
		owner = _owner;
		default_type = _default_type;
		timers = [];
		name = "__timersystem__";
	}
	
	#region // system management.
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
	
	/// @func	set(_dur, _name, _func, _dur_type);
	/// @param	{int}	_dur		the duration of the timer to set
	/// @param	{any}	_name		the name of the timer
	/// @param	{func}	_func		the function to run when the timer runs out
	/// @param	{int}	[_dur_type]	the type of timer to set. defaults to global timer type.
	set = function(_dur, _name, _func, _dur_type = _this.default_type) {
		if(index(_name) == undefined)array_push(_this.timers, new __timer(_dur, _name, _func, _dur_type));
		show_debug_message(time(_name));
		return true;
	}
	
	/// @func	execute(_name);
	/// @param	{any}	_name	the name of the timer
	execute = function(_name) {
		var _i = index(_name);
		if(_i != undefined) {
			var _t = _this.timers[int];
			array_delete(_this.timers, int, 1);
			_t.func();
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
	/// @param	{any}	_name		the name of the timer
	/// @param	{int}	[_type]		the optional type to return time in. returns based on what type the timer was created with.
	time = function(_name, _type = undefined) {
		var _t = get(_name);
		if(_t != undefined) {
			return __decode_time(_t.start_time + __encode_time(_t) - current_time, (_type != undefined) ? _type : _t.dur_type);
		} else {
			show_debug_message("no timer exists with this name.");
			return false;
		}
	}
	
	/// @func	check();
	check = function() {
		for(var int = 0; int < array_length(_this.timers); int++) {
			if(_this.timers[int].start_time + __encode_time(_this.timers[int]) <= current_time) {
				var _t = _this.timers[int];
				array_delete(_this.timers, int, 1);
				_t.func();
				
			}
		}
	}
	#endregion
	
	#region // timer encoding. for internal use.
	/// @func	__encode_time(_timer);
	/// @param	{struct}	_timer	the input timer
	__encode_time = function(_timer) {
		switch(_timer.dur_type) {
			case TIMER_TYPE.MILLISECONDS:
			return _timer.dur;
			
			case TIMER_TYPE.SECONDS:
			return (_timer.dur * 1000);
			
			case TIMER_TYPE.FRAMES:
			return ((_timer.dur * 1000) / (room_speed));
		}
	}
	
	/// @func	__decode_time(_time, _type);
	/// @param	{int}	_time	the amount of time to convert
	/// @param	{int}	_type	the type to convert to
	__decode_time = function(_time, _type) {
		switch(_type) {
			case TIMER_TYPE.MILLISECONDS:
			return _time;
			
			case TIMER_TYPE.SECONDS:
			return (_time / 1000);
			
			case TIMER_TYPE.FRAMES:
			return ((_time / 1000) * (room_speed));
			
		}
	}
	#endregion
}

/// @func	__timer(_dur, _name, _func, _dur_type);
/// @param	{int}	_dur			the duration of the timer
/// @param	{str}	_name			the name of the timer
/// @param	{func}	_func			the function to run when the timer duration runs out
/// @param	{int}	_dur_type		the type of duration that has been input. defaults to the global default
function __timer(_dur, _name, _func, _dur_type) constructor {
	start_time = current_time;
	name = _name;
	dur = _dur;
	dur_type = _dur_type;
	func = _func;
}

#region // Settings
enum TIMER_TYPE {
	MILLISECONDS,
	SECONDS,
	FRAMES
}

#macro TIMER_DEFAULT_SETTING TIMER_TYPE.MILLISECONDS
#endregion