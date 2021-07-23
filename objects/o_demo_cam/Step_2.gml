if(instance_exists(o_demo_player)) {
	camera_set_view_pos(view_camera[0], o_demo_player.x - camera.w/2, o_demo_player.y - 32 - camera.h/2);
}