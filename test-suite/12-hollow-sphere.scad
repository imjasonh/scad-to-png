// Hollow sphere with holes
difference() {
    sphere(r = 20, $fn = 50);
    sphere(r = 18, $fn = 50);
    
    // Add some holes
    for (a = [0:45:90]) {
        rotate([a, 0, 0])
            cylinder(h = 50, r = 5, center = true, $fn = 20);
    }
}
