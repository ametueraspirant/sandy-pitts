set_base_stats(100, 10, 5, 0.6, 0.3);

mstrat = new TopDownStrat();
mstrat.add_collider([o_demo_wall, o_demo_obstacle], "collide");