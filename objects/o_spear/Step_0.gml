if(instance_exists(o_player)) {
	x = o_player.x + (3 * o_player.mv_sign);
	y = o_player.y - 5;
	depth = -y -7;
	image_angle = o_player.look_dir;
	image_xscale = o_player.mv_sign;
}