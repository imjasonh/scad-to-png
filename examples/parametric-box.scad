// Parametric box with customizable dimensions
// Default values
width = 20;
height = 10;
depth = 15;
wall_thickness = 2;
has_lid = false;

difference() {
    // Outer box
    cube([width, depth, height]);
    
    // Inner cavity
    translate([wall_thickness, wall_thickness, wall_thickness])
        cube([width - 2*wall_thickness, 
              depth - 2*wall_thickness, 
              height - (has_lid ? wall_thickness : 0)]);
}

// Optional lid
if (has_lid) {
    translate([0, depth + 5, 0])
        cube([width, depth, wall_thickness]);
}