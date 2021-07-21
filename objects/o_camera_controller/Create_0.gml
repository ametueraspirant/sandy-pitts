#region // init camera to view[0]
#macro _main_camera view_camera[0]

camera = {
	w: 1920/6,
	h: 1080/6,
	xx: 0,
	yy: 0,
	scale: 3
}

// set window and camera size to desired parameters
window_set_size(camera.w * camera.scale, camera.h * camera.scale);
alarm[0] = 1;
surface_resize(application_surface, camera.w * camera.scale, camera.h * camera.scale);
camera_set_view_size(_main_camera, camera.w, camera.h);

// set camera x and y
camera.xx = (camera.w / 2);
camera.yy = (camera.h / 2);
#endregion

#region // set up state machine
// make new state machine object
cam = new SnowState("following");

// define events
cam.event_set_default_function("endstep", function() {});

// define states
cam.add("following", {
	enter: function() {
		show_debug_message("now following player");
	},
	endstep: function () {
		if(instance_exists(o_player)) {
			camera.xx = o_player.x;
			camera.yy = o_player.y;
			camera_set_view_pos(_main_camera, camera.xx, camera.yy);
		}
	}
});
#endregion