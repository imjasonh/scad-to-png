// Organic shape using chained hull operations
module organic_shape() {
    // Create a smooth organic form by hulling spheres along a path
    steps = 20;
    for (i = [0:steps-1]) {
        hull() {
            // Current position
            rotate([0, 0, i * 360 / steps])
                translate([15, 0, i * 2])
                sphere(r = 5 - i/10, $fn = 20);
            
            // Next position
            rotate([0, 0, (i+1) * 360 / steps])
                translate([15, 0, (i+1) * 2])
                sphere(r = 5 - (i+1)/10, $fn = 20);
        }
    }
}

organic_shape();