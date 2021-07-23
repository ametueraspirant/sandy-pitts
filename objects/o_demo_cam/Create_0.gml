camera = {
	w: 1920/3,
	h: 1080/3,
	scale: 2
}

// set window and camera size to desired parameters
window_set_size(camera.w * camera.scale, camera.h * camera.scale);
alarm[0] = 1;
surface_resize(application_surface, camera.w * camera.scale, camera.h * camera.scale);
camera_set_view_size(view_camera[0], camera.w, camera.h);