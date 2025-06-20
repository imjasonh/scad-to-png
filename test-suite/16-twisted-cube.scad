// Twisted cube using hull
hull() {
    cube([20, 20, 1]);
    
    translate([0, 0, 30])
        rotate([0, 0, 90])
        cube([20, 20, 1]);
}