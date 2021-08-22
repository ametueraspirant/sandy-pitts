owner = noone;

attack_list = [];

/* example: act stores the sequence of the current attack. link_light points to the array value for a chainable light attack
while link_heavy points to the array value for a chainable heavy attack. if false, reset the combo and add a cooldown.
be sure to comment the array value for each line to avoid confusion
array[0] will hold the weapon's stats like end lag.
attack_list = [
	{ end_lag: 150, other stats go here }, // 0 - reserved for attack stats
	{ act: q_light_1, link_light: 2, link_heavy: 4 }, // 1
	{ act: q_light_2, link_light: 3, link_heavy: 5 }, // 2
	{ act: q_light_3, link_light: false, link_heavy: 5 }, // 3
	{ act: q_heavy_1, link_light: false, link_heavy: 5 }, // 4
	{ act: q_heavy_ 2, link_light: false, link_heavy: false } // 5
];