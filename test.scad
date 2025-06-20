// Simple test object - a cube with a cylinder hole
difference() {
    // Main cube
    cube([30, 30, 30], center = true);
    
    // Cylinder hole through the center
    cylinder(h = 40, r = 10, center = true, $fn = 50);
}

// Add a sphere on top
translate([0, 0, 25])
    sphere(r = 8, $fn = 50);