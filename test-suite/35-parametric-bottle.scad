// Parametric bottle with smooth transitions
module parametric_bottle(height, base_radius, neck_radius, body_radius) {
    sections = 30;
    
    // Define profile points
    profile_points = [
        [0, 0, 0],
        [base_radius, 0, 1],
        [body_radius, 0, height * 0.3],
        [body_radius * 0.9, 0, height * 0.7],
        [neck_radius * 1.5, 0, height * 0.85],
        [neck_radius, 0, height * 0.9],
        [neck_radius, 0, height],
        [0, 0, height]
    ];
    
    // Rotate profile around Z axis
    rotate_extrude($fn = 60)
        polygon(points = [
            for (p = profile_points) [p[0], p[2]]
        ]);
    
    // Add threading to neck
    translate([0, 0, height * 0.9])
    difference() {
        cylinder(h = height * 0.08, r = neck_radius + 1, $fn = 30);
        cylinder(h = height * 0.08, r = neck_radius, $fn = 30);
        
        // Thread groove
        linear_extrude(height = height * 0.08, twist = 360)
            translate([neck_radius, 0, 0])
            square([2, 1]);
    }
}

parametric_bottle(40, 10, 3, 12);