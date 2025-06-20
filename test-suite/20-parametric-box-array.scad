// Parametric array of boxes with varying heights
rows = 4;
cols = 4;
base_size = 8;
spacing = 10;
max_height = 20;

for (row = [0:rows-1]) {
    for (col = [0:cols-1]) {
        height = max_height * (1 - sqrt(pow(row - 1.5, 2) + pow(col - 1.5, 2)) / 3);
        
        translate([col * spacing, row * spacing, 0])
            cube([base_size, base_size, max(height, 1)]);
    }
}