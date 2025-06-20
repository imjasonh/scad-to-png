// Parametric compression spring with variable pitch
coils = 8;
height = 40;
outer_radius = 15;
wire_radius = 1.5;
compression = 0.3; // 0 = relaxed, 1 = fully compressed

module spring(coils, height, outer_r, wire_r, compression) {
    steps_per_coil = 20;
    total_steps = coils * steps_per_coil;
    
    for (i = [0:total_steps-1]) {
        hull() {
            // Variable pitch based on compression
            z1 = (i / total_steps) * height * (1 - compression);
            z2 = ((i + 1) / total_steps) * height * (1 - compression);
            
            rotate([0, 0, i * 360 / steps_per_coil])
                translate([outer_r, 0, z1])
                sphere(r = wire_r, $fn = 10);
                
            rotate([0, 0, (i + 1) * 360 / steps_per_coil])
                translate([outer_r, 0, z2])
                sphere(r = wire_r, $fn = 10);
        }
    }
}

spring(coils, height, outer_radius, wire_radius, compression);
