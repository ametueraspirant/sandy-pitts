if(instance_exists(o_player)) {
	if(!o_player.class.is_attacking()) {
		x = o_player.x;
		y = o_player.y;
		depth = -y;
		image_angle = o_player.look_dir -45;
	}
}