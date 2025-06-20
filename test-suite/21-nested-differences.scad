// Nested difference operations - Swiss cheese cube
difference() {
    cube([40, 40, 40], center = true);
    
    // Large central hole
    sphere(r = 15, $fn = 40);
    
    // Array of smaller holes
    for (x = [-15, 0, 15]) {
        for (y = [-15, 0, 15]) {
            for (z = [-15, 0, 15]) {
                translate([x, y, z])
                    sphere(r = 4, $fn = 20);
            }
        }
    }
    
    // Cylindrical tunnels
    cylinder(h = 50, r = 3, center = true, $fn = 20);
    rotate([90, 0, 0])
        cylinder(h = 50, r = 3, center = true, $fn = 20);
    rotate([0, 90, 0])
        cylinder(h = 50, r = 3, center = true, $fn = 20);
}