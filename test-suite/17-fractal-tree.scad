// Simple fractal tree
module branch(length, level) {
    if (level > 0) {
        cylinder(h = length, r1 = length/10, r2 = length/15, $fn = 8);
        
        translate([0, 0, length])
        rotate([30, 0, 0])
            branch(length * 0.7, level - 1);
        
        translate([0, 0, length])
        rotate([-30, 0, 120])
            branch(length * 0.7, level - 1);
        
        translate([0, 0, length])
        rotate([30, 0, 240])
            branch(length * 0.7, level - 1);
    }
}

branch(20, 4);