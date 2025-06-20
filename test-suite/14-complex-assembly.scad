// Complex assembly with multiple parts
// Base plate
cube([40, 40, 5]);

// Pillars
for (x = [5, 35], y = [5, 35]) {
    translate([x, y, 5])
        cylinder(h = 20, r = 3, $fn = 20);
}

// Top plate with hole
translate([0, 0, 25])
    difference() {
        cube([40, 40, 3]);
        translate([20, 20, -1])
            cylinder(h = 5, r = 8, $fn = 30);
    }