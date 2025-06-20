// Simple gear example
module gear(teeth = 20, radius = 10, thickness = 5) {
    cylinder(h = thickness, r = radius, $fn = teeth * 2);
    for (i = [0:teeth-1]) {
        rotate([0, 0, i * 360 / teeth])
        translate([radius, 0, 0])
        cylinder(h = thickness, r = radius / 4, $fn = 8);
    }
}

gear();