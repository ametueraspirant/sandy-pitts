if(instance_exists(o_player)) {
	if(!o_player.class.is_attacking()) {
		x = o_player.x + (3 * o_player.mv_sign);
		y = o_player.y - 5;
		depth = -y -6;
		image_angle = point_direction(x, y, mouse_x, mouse_y) - 45;
	}
}