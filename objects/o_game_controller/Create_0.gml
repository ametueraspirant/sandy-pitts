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
game = new SnowState("test");

// define default events
game.event_set_default_function("step", function() {});
game.event_set_default_function("drawGUI", function() {});

// define states
game.add("test", {
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