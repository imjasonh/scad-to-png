// Bezier surface patch using polyhedron
function bezier_point(t, p0, p1, p2, p3) = 
    pow(1-t, 3) * p0 + 
    3 * pow(1-t, 2) * t * p1 + 
    3 * (1-t) * pow(t, 2) * p2 + 
    pow(t, 3) * p3;

function bezier_surface(u, v, control_points) = 
    bezier_point(v,
        bezier_point(u, control_points[0][0], control_points[0][1], 
                       control_points[0][2], control_points[0][3]),
        bezier_point(u, control_points[1][0], control_points[1][1], 
                       control_points[1][2], control_points[1][3]),
        bezier_point(u, control_points[2][0], control_points[2][1], 
                       control_points[2][2], control_points[2][3]),
        bezier_point(u, control_points[3][0], control_points[3][1], 
                       control_points[3][2], control_points[3][3])
    );

// Control points for a wavy surface
control_points = [
    [[0, 0, 0], [10, 0, 5], [20, 0, 5], [30, 0, 0]],
    [[0, 10, 5], [10, 10, 10], [20, 10, 10], [30, 10, 5]],
    [[0, 20, 5], [10, 20, 10], [20, 20, 10], [30, 20, 5]],
    [[0, 30, 0], [10, 30, 5], [20, 30, 5], [30, 30, 0]]
];

// Generate surface
resolution = 15;
points = [
    for (ui = [0:resolution])
        for (vi = [0:resolution])
            bezier_surface(ui/resolution, vi/resolution, control_points)
];

faces = [
    for (ui = [0:resolution-1])
        for (vi = [0:resolution-1])
            let (base = ui * (resolution + 1) + vi)
            [base, base + 1, base + resolution + 2, base + resolution + 1]
];

polyhedron(points = points, faces = faces);