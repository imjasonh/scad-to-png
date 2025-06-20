// Interlocking gear train system
module gear(teeth, radius, thickness, hole_radius = 0) {
    difference() {
        union() {
            // Main gear body
            cylinder(h = thickness, r = radius * 0.9, $fn = teeth);
            
            // Teeth
            for (i = [0:teeth-1]) {
                rotate([0, 0, i * 360 / teeth])
                    translate([radius, 0, 0])
                    cylinder(h = thickness, r = radius / 5, $fn = 6);
            }
        }
        
        // Center hole
        if (hole_radius > 0)
            cylinder(h = thickness + 1, r = hole_radius, center = true, $fn = 20);
    }
}

// Gear specifications
gear1_teeth = 20;
gear2_teeth = 15;
gear3_teeth = 10;
module_size = 1;
thickness = 5;

// Calculate radii
gear1_radius = gear1_teeth * module_size;
gear2_radius = gear2_teeth * module_size;
gear3_radius = gear3_teeth * module_size;

// Place gears
rotate([0, 0, $t * 360])
    gear(gear1_teeth, gear1_radius, thickness, 3);

translate([gear1_radius + gear2_radius, 0, 0])
    rotate([0, 0, -$t * 360 * gear1_teeth / gear2_teeth])
    gear(gear2_teeth, gear2_radius, thickness, 2);

translate([gear1_radius + gear2_radius, gear2_radius + gear3_radius, 0])
    rotate([0, 0, $t * 360 * gear1_teeth / gear3_teeth])
    gear(gear3_teeth, gear3_radius, thickness, 2);