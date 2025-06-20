// Knurled cylinder with diamond pattern
module knurled_cylinder(height, radius, knurl_depth, knurl_count) {
    difference() {
        // Base cylinder
        cylinder(h = height, r = radius, $fn = 60);
        
        // First set of helical grooves
        for (i = [0:knurl_count-1]) {
            rotate([0, 0, i * 360 / knurl_count])
            linear_extrude(height = height * 1.2, twist = 360)
                translate([radius - knurl_depth/2, 0, 0])
                square([knurl_depth, knurl_depth/2], center = true);
        }
        
        // Second set of helical grooves (opposite direction)
        for (i = [0:knurl_count-1]) {
            rotate([0, 0, i * 360 / knurl_count])
            linear_extrude(height = height * 1.2, twist = -360)
                translate([radius - knurl_depth/2, 0, 0])
                square([knurl_depth, knurl_depth/2], center = true);
        }
    }
}

knurled_cylinder(30, 10, 0.5, 30);