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
// make new state machine object
game = new SnowState("logos");

// define default variables
game.event_set_default_function("step", function() {});
game.event_set_default_function("draw", function() { draw_self() });

game.add("logos", {
	enter: function() {
		game.change("menu");
	}
});

game.add("menu", {
	enter: function() {
		
	}
});
#endregion

randomise();