if(instance_exists(o_player)) {
	x = o_player.x;
	y = o_player.y - 5;
	depth = -y -10;
	image_angle = point_direction(x, y, mouse_x, mouse_y);
}