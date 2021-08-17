#region // global innate variables
#macro _entity_layer "Entities"
#macro _env_layer "Environment"

global.debug = false;
global.inputs = false;
#endregion

#region // create other game instances
instance_create_layer(0, 0, _entity_layer, o_input_manager);
instance_create_layer(0, 0, _entity_layer, o_camera_controller);
instance_create_layer(0, 0, _entity_layer, o_menu_controller);
#endregion

#region // set up state machine
// define new state machine
state = new SnowState("test");

// define default events
state.event_set_default_function("step", function() {});
state.event_set_default_function("draw_gui", function() {});

// define states
state.add("start_up", {
	enter: function() {
		show_debug_message("game is starting");
	},
	step: function() {
		show_debug_message("placeholder for starting logos");
		state.change("main_menu");
	},
	draw_gui: function() {
		draw_text(20, 20, "lol starting logos");
	}
});

state.add("menu", {
	enter: function() {
		show_debug_message("main menu");
	},
	step: function() {
		
	},
	draw_gui: function() {
		draw_text(20, 20, "lol menu");
	}
});

// #TEST
state.add("test", {
	enter: function() {
		if(!instance_exists(o_player)) {
			instance_create_layer(700, 300, _entity_layer, o_player);
			show_debug_message("player spawned");
		}
	},
	step: function() {
		
	}
});
#endregion

randomise();