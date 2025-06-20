// Complex polygon with holes extruded with twist
module complex_shape() {
    // Outer shape - star
    outer_points = [
        for (i = [0:9]) 
            let (angle = i * 36)
            let (r = (i % 2) ? 20 : 10)
            [r * cos(angle), r * sin(angle)]
    ];
    
    // Inner hole - pentagon
    hole_points = [
        for (i = [0:4])
            let (angle = i * 72)
            [5 * cos(angle), 5 * sin(angle)]
    ];
    
    linear_extrude(height = 30, twist = 180, slices = 50)
        difference() {
            polygon(points = outer_points);
            polygon(points = hole_points);
        }
}

complex_shape();