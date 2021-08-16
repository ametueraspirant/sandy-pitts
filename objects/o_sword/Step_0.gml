if(instance_exists(o_player)) {
	if(!o_player.class.is_attacking()) {
		x = o_player.x + (3 * o_player.mv_sign);
		y = o_player.y - 5;
		depth = -y -6;
		image_angle = o_player.look_dir;
	}
}