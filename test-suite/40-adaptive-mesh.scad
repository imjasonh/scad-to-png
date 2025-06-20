// Adaptive mesh refinement based on curvature
module adaptive_mesh_sphere() {
    // Create sphere with varying detail based on viewing angle
    
    // High detail front hemisphere
    intersection() {
        sphere(r = 20, $fn = 80);
        translate([10, 0, 0])
            cube([40, 40, 40], center = true);
    }
    
    // Medium detail sides
    intersection() {
        sphere(r = 20, $fn = 40);
        difference() {
            cube([40, 40, 40], center = true);
            translate([10, 0, 0])
                cube([40, 40, 40], center = true);
            translate([-30, 0, 0])
                cube([40, 40, 40], center = true);
        }
    }
    
    // Low detail back
    intersection() {
        sphere(r = 20, $fn = 20);
        translate([-30, 0, 0])
            cube([40, 40, 40], center = true);
    }
    
    // Add surface features that need high detail
    for (i = [0:5]) {
        rotate([0, i * 60, 0])
            translate([20, 0, 0])
            sphere(r = 2, $fn = 30);
    }
}

adaptive_mesh_sphere();