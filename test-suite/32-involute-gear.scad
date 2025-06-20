// Mathematically accurate involute gear profile
function involute(base_radius, t) = 
    base_radius * [cos(t) + t * sin(t), sin(t) - t * cos(t)];

module involute_gear(teeth, module_size, pressure_angle = 20) {
    pitch_radius = teeth * module_size / 2;
    base_radius = pitch_radius * cos(pressure_angle);
    addendum = module_size;
    dedendum = 1.25 * module_size;
    
    tooth_angle = 360 / teeth;
    
    // Generate tooth profile points
    involute_steps = 10;
    tooth_profile = [
        for (t = [0:1/involute_steps:1])
            involute(base_radius, t * 0.5)
    ];
    
    difference() {
        union() {
            // Base circle
            cylinder(h = 5, r = pitch_radius - dedendum, $fn = teeth * 2);
            
            // Teeth
            for (i = [0:teeth-1]) {
                rotate([0, 0, i * tooth_angle])
                linear_extrude(height = 5)
                    polygon(points = concat(
                        [[0, 0]],
                        tooth_profile,
                        [for (p = reverse(tooth_profile)) [p.x, -p.y]]
                    ));
            }
        }
        
        // Center hole
        cylinder(h = 6, r = pitch_radius / 4, center = true, $fn = 20);
    }
}

involute_gear(24, 2);