// Mathematical surface - saddle shape using polyhedron
size = 20;
resolution = 20;
height_scale = 5;

// Generate grid points with saddle function z = x² - y²
points = [
    for (xi = [0:resolution])
        for (yi = [0:resolution])
            let (x = (xi / resolution - 0.5) * size)
            let (y = (yi / resolution - 0.5) * size)
            let (z = (x*x - y*y) / size * height_scale)
            [x, y, z]
];

// Generate faces connecting the points
faces = [
    for (xi = [0:resolution-1])
        for (yi = [0:resolution-1])
            let (base = xi * (resolution + 1) + yi)
            each [
                [base, base + 1, base + resolution + 2, base + resolution + 1],
            ]
];

polyhedron(points = points, faces = faces);