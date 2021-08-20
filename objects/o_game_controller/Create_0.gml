#region // global innate variables
#macro _entity_layer "Entities"
#macro _fore_layer "Foreground"
#macro _back_layer "Background"
#macro _env_layer "Environment"

global.debug = false;
global.players = [];
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
state
.event_set_default_function("step", function() {})
.event_set_default_function("draw_gui", function() {})
.add("start_up", {
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
})
.add("menu", {
	enter: function() {
		show_debug_message("main menu");
	},
	step: function() {
		
	},
	draw_gui: function() {
		draw_text(20, 20, "lol menu");
	}
})
.add("ingame", {
	enter: function() {
		
	},
	step: function() {
		
	}
})

// #TEST
state.add("test", {
	enter: function() {
		var num = 0;
		repeat(4) {
			var player = instance_create_layer(240 + num*20, 160, _entity_layer, o_player);
			player.player_num = num;
			show_debug_message("player " + string(num) + " spawned");
			num++;
		}
	},
	step: function() {
		
	}
});
#endregion

randomise();