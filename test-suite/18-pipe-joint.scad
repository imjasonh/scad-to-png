// Pipe joint/elbow
difference() {
    union() {
        // Main body
        sphere(r = 15, $fn = 40);
        
        // Three pipes
        cylinder(h = 25, r = 10, $fn = 30);
        
        rotate([90, 0, 0])
            cylinder(h = 25, r = 10, $fn = 30);
            
        rotate([0, 90, 0])
            cylinder(h = 25, r = 10, $fn = 30);
    }
    
    // Hollow interior
    sphere(r = 12, $fn = 40);
    
    cylinder(h = 30, r = 8, $fn = 30);
    
    rotate([90, 0, 0])
        cylinder(h = 30, r = 8, $fn = 30);
        
    rotate([0, 90, 0])
        cylinder(h = 30, r = 8, $fn = 30);
}