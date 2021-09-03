owner = noone;

attacks = new AttackList({
	stats: { end_lag: 50, reset_time: 500, light_start: q_ek_light_1, heavy_start: q_ek_heavy },
	list: [
		new Attack({ type: ACTIONTYPE.INSTANT,
					 action: q_ek_light_1,
					 link_light: q_ek_light_2,
					 link_heavy: q_ek_heavy,
					 attack_frame: 5,
					 reset_frame: 18,
					 damage_multi: 1 }),
		new Attack({ type: ACTIONTYPE.INSTANT,
					 action: q_ek_light_2,
					 link_light: q_ek_light_1,
					 link_heavy: q_ek_heavy,
					 attack_frame: 5,
					 reset_frame: 18,
					 damage_multi: 1 }),
		new Attack({ type: ACTIONTYPE.CHARGE,
					 action: q_ek_heavy,
					 link_light: noone,
					 link_heavy: noone,
					 attack_frame: 5,
					 reset_frame: 18,
					 charge_end_frame: 15,
					 charge_min: 8,
					 damage_multi: 0.2 }) //# seq is unfinished
	]
});

show_debug_message(attacks);