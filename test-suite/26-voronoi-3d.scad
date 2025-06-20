// 3D Voronoi-inspired cellular structure
seed_points = [
    [0, 0, 0], [10, 5, 8], [-8, 7, -5], [6, -9, 3],
    [-5, -6, 7], [8, 8, -8], [-7, 3, 9], [4, -4, -6]
];

module voronoi_cell(point, size = 40) {
    intersection() {
        // Start with a large cube
        cube(size, center = true);
        
        // Cut with planes perpendicular to lines connecting to other points
        for (other = seed_points) {
            if (other != point) {
                midpoint = (point + other) / 2;
                normal = other - point;
                
                translate(midpoint)
                    rotate([0, acos(normal.z / norm(normal)), 
                           atan2(normal.y, normal.x)])
                    translate([0, 0, -size])
                        cube([size*2, size*2, size*2], center = true);
            }
        }
    }
}

// Create all cells
for (point = seed_points) {
    translate(point)
        voronoi_cell(point, 30);
}