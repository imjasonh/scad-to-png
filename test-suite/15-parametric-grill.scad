// Parametric grill/mesh
width = 40;
height = 30;
thickness = 3;
bar_width = 2;
spacing = 5;

difference() {
    // Frame
    cube([width, height, thickness]);
    
    // Cut out center
    translate([thickness, thickness, -1])
        cube([width - 2*thickness, height - 2*thickness, thickness + 2]);
}

// Horizontal bars
for (y = [thickness + spacing : spacing : height - thickness - spacing]) {
    translate([0, y - bar_width/2, 0])
        cube([width, bar_width, thickness]);
}

// Vertical bars
for (x = [thickness + spacing : spacing : width - thickness - spacing]) {
    translate([x - bar_width/2, 0, 0])
        cube([bar_width, height, thickness]);
}