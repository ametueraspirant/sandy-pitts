depth = -y;
var x_dir = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var y_dir = keyboard_check(ord("S")) - keyboard_check(ord("W"));
mstrat.move(x_dir, y_dir);

if(keyboard_check_pressed(vk_shift))mstrat.dash(x_dir, y_dir);