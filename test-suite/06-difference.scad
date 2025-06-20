// Difference operation - cube with spherical cavity
difference() {
    cube([30, 30, 30], center = true);
    sphere(r = 18, $fn = 50);
}