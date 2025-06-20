// Compound planetary gear system
module ring_gear(teeth, module_size, thickness) {
    pitch_radius = teeth * module_size / 2;
    
    difference() {
        cylinder(h = thickness, r = pitch_radius + module_size * 2, $fn = 60);
        
        // Inner gear teeth
        for (i = [0:teeth-1]) {
            rotate([0, 0, i * 360 / teeth])
                translate([pitch_radius, 0, -1])
                cylinder(h = thickness + 2, r = module_size, $fn = 6);
        }
    }
}

module planet_gear(teeth, module_size, thickness) {
    pitch_radius = teeth * module_size / 2;
    
    difference() {
        union() {
            cylinder(h = thickness, r = pitch_radius - module_size/2, $fn = teeth);
            
            for (i = [0:teeth-1]) {
                rotate([0, 0, i * 360 / teeth])
                    translate([pitch_radius, 0, 0])
                    cylinder(h = thickness, r = module_size * 0.8, $fn = 6);
            }
        }
        
        cylinder(h = thickness + 1, r = 2, center = true, $fn = 20);
    }
}

// System parameters
sun_teeth = 12;
planet_teeth = 8;
ring_teeth = sun_teeth + 2 * planet_teeth;
module_size = 1;
thickness = 5;

// Sun gear (center)
rotate([0, 0, $t * 360])
    planet_gear(sun_teeth, module_size, thickness);

// Planet gears
for (i = [0:2]) {
    rotate([0, 0, i * 120 + $t * 120])
        translate([(sun_teeth + planet_teeth) * module_size / 2, 0, 0])
        rotate([0, 0, -$t * 360 * (ring_teeth / planet_teeth)])
        planet_gear(planet_teeth, module_size, thickness);
}

// Ring gear
ring_gear(ring_teeth, module_size, thickness);