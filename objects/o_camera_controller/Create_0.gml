#region // init camera to view[0]
#macro _main_camera view_camera[0]

camera = {
	w: 1920/3,
	h: 1080/3,
	scale: 2
}

// set window and camera size to desired parameters
window_set_size(camera.w * camera.scale, camera.h * camera.scale);
alarm[0] = 1;
surface_resize(application_surface, camera.w * camera.scale, camera.h * camera.scale);
camera_set_view_size(_main_camera, camera.w, camera.h);
#endregion

#region // set up state machine
// define new state machine
cam = new SnowState("following");

// define default events
cam.event_set_default_function("endstep", function() {});

// define states
cam.add("following", {
	enter: function() {
		show_debug_message("now following player");
	},
	endstep: function () {
		if(instance_exists(o_player)) {
			camera_set_view_pos(_main_camera, o_player.x - camera.w/2, o_player.y - 32 - camera.h/2);
		}
	}
});
#endregion