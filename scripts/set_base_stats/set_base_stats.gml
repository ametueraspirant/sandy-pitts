// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_base_stats(_owner, _hp, _damage, _max_spd, _accel, _frict){
	with(_owner) {
		has_base_stats = true;
		hp = _hp;
		dam = _damage;
		max_spd = _max_spd;
		base_max_spd = _max_spd;
		accel = _accel;
		base_accel = _accel;
		frict = _frict;
		base_frict = _frict;
		spd = new Vector2(0, 0);
	}
}