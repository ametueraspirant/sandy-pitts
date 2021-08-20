depth = -y;
var x_dir = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var y_dir = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var mv_dir = point_direction(0, 0, x_dir, y_dir);
var mv_mag = point_distance(0, 0, x_dir, y_dir);
mstrat.move(mv_dir, mv_mag);

if(keyboard_check_pressed(vk_shift))mstrat.dash(mv_dir, mv_mag);