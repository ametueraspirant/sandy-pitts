if(instance_exists(o_player)) {
	x = o_player.x + (3 * o_player.mv_sign);
	y = o_player.y - 5;
	depth = -y -7;
	image_angle = point_direction(x, y, mouse_x, mouse_y);
	image_xscale = o_player.mv_sign;
}