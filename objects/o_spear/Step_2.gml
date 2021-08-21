if(instance_exists(owner)) {
	x = owner.x + (3 * owner.mv_sign);
	y = owner.y - 5;
	depth = -y -7;
	image_angle = owner.look_dir;
	image_xscale = owner.mv_sign;
}