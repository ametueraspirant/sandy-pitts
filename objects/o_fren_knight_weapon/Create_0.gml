set_item_stats({ type: GEARTYPES.WEAPON, damage: 10 });

gear = new GearItem(noone, -95, 0, 0, -20);

attacks = new AttackList({
	stats: { end_lag: 50, reset_time: 300, light_start: q_fk_inst_1, heavy_start: q_fk_inst_3 },
	list: [
		new Attack({ type: ACTIONTYPE.INSTANT,
					 action: q_fk_inst_1,
					 link_light: q_fk_inst_2,
					 link_heavy: q_fk_inst_3,
					 attack_frame: 5,
					 reset_frame: 18,
					 damage_multi: 1 }),
		new Attack({ type: ACTIONTYPE.INSTANT,
					 action: q_fk_inst_2,
					 link_light: q_fk_inst_3,
					 link_heavy: q_fk_inst_3,
					 attack_frame: 5,
					 reset_frame: 18,
					 damage_multi: 1 }),
		new Attack({ type: ACTIONTYPE.INSTANT,
					 action: q_fk_inst_3,
					 link_light: noone,
					 link_heavy: noone,
					 attack_frame: 5,
					 reset_frame: 18,
					 damage_multi: 0.2 }),
	]
});