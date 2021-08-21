if(instance_exists(owner)) {
	if(!owner.class.is_attacking()) {
		x = owner.x;
		y = owner.y;
		depth = -y -10;
		image_angle = owner.look_dir - 90;
	}
}