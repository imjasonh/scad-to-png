// Complex boolean operations creating artistic form
module boolean_sculpture() {
    difference() {
        // Start with a sphere
        sphere(r = 20, $fn = 60);
        
        // Subtract rotating cubes
        for (angle = [0:30:180]) {
            rotate([angle, angle/2, angle/3])
                cube([30, 8, 8], center = true);
        }
        
        // Subtract cylinders in multiple directions
        for (axis = [[1,0,0], [0,1,0], [0,0,1], [1,1,0], [1,0,1], [0,1,1]]) {
            rotate(axis * 90)
                cylinder(h = 50, r = 3, center = true, $fn = 20);
        }
    }
    
    // Add intersecting tori
    intersection() {
        rotate([90, 0, 0])
            rotate_extrude($fn = 40)
            translate([15, 0, 0])
            circle(r = 3, $fn = 20);
            
        rotate([0, 90, 0])
            rotate_extrude($fn = 40)
            translate([15, 0, 0])
            circle(r = 3, $fn = 20);
    }
}

boolean_sculpture();