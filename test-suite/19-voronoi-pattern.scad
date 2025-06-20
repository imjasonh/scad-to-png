// Simplified voronoi-like pattern
seed_points = [
    [10, 10], [25, 15], [15, 25], [30, 30],
    [5, 20], [20, 5], [35, 20], [20, 35]
];

difference() {
    // Base plate
    cube([40, 40, 3]);
    
    // Cut circles around each point
    for (p = seed_points) {
        translate([p[0], p[1], -1])
            cylinder(h = 5, r = 6, $fn = 20);
    }
}