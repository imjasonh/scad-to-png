// Complex nested lattice structure
module lattice_unit(size, thickness) {
    // Create a unit cell with diagonal supports
    difference() {
        cube(size, center = true);
        
        // Hollow out the center
        cube(size - thickness * 2, center = true);
        
        // Cut out faces to create openings
        for (axis = [[1,0,0], [0,1,0], [0,0,1]]) {
            rotate(90 * axis)
                cube([size * 0.6, size * 0.6, size * 1.1], center = true);
        }
    }
    
    // Add diagonal struts
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            for (z = [-1, 1]) {
                hull() {
                    translate([x * size/3, y * size/3, z * size/3])
                        sphere(thickness/2, $fn = 8);
                    sphere(thickness/2, $fn = 8);
                }
            }
        }
    }
}

// Create 3x3x3 lattice
for (x = [-1:1]) {
    for (y = [-1:1]) {
        for (z = [-1:1]) {
            translate([x * 10, y * 10, z * 10])
                lattice_unit(10, 0.8);
        }
    }
}