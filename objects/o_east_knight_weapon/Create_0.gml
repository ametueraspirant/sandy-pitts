set_item_stats({ type: GEARTYPES.WEAPON, damage: 10 });

gear = new GearItem(noone, -95);

attacks = new AttackList({
	stats: { reset_time: 500, light_start: q_ek_inst_1, heavy_start: q_ek_charge },
	list: [
		new Attack({ type: ACTIONTYPE.INSTANT,
					 action: q_ek_inst_1,
					 link_light: q_ek_inst_2,
					 link_heavy: q_ek_charge,
					 attack_frame: 5,
					 reset_frame: 20,
					 damage_multi: 1 }),
		new Attack({ type: ACTIONTYPE.INSTANT,
					 action: q_ek_inst_2,
					 link_light: q_ek_inst_1,
					 link_heavy: q_ek_charge,
					 attack_frame: 5,
					 reset_frame: 20,
					 damage_multi: 1 }),
		new Attack({ type: ACTIONTYPE.CHARGE,
					 action: q_ek_charge,
					 link_light: noone,
					 link_heavy: noone,
					 attack_frame: 5,
					 reset_frame: 30,
					 charge_min: 8,
					 charge_end: 15,
					 damage_multi: 0.2 })
	]
});