// Complex swept path - 3D spiral with varying cross-section
module swept_spiral() {
    steps = 100;
    height = 50;
    base_radius = 20;
    
    for (i = [0:steps-1]) {
        t = i / steps;
        next_t = (i + 1) / steps;
        
        // Path parameters
        angle1 = t * 720;  // Two full rotations
        angle2 = next_t * 720;
        z1 = t * height;
        z2 = next_t * height;
        
        // Varying radius
        r1 = base_radius * (1 - t * 0.7);
        r2 = base_radius * (1 - next_t * 0.7);
        
        // Varying cross-section size
        section_size1 = 3 * (1 + sin(t * 360 * 3) * 0.5);
        section_size2 = 3 * (1 + sin(next_t * 360 * 3) * 0.5);
        
        // Create segment
        hull() {
            translate([r1 * cos(angle1), r1 * sin(angle1), z1])
                sphere(r = section_size1, $fn = 8);
                
            translate([r2 * cos(angle2), r2 * sin(angle2), z2])
                sphere(r = section_size2, $fn = 8);
        }
    }
}

swept_spiral();