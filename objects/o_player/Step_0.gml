player.gstep();
player.step();

if(keyboard_check_pressed(vk_space))mstrat.timer_set(1000 * 10, "test", function(){});

mstrat.timer_get_remaining_time("test");