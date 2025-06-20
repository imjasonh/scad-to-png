// Union of two shapes
union() {
    cube([20, 20, 20]);
    translate([10, 10, 10])
        sphere(r = 15, $fn = 40);
}