// Custom polyhedron - pyramid
polyhedron(
    points = [
        [10, 10, 0], [-10, 10, 0], [-10, -10, 0], [10, -10, 0],  // base
        [0, 0, 20]  // apex
    ],
    faces = [
        [0, 1, 2, 3],  // base
        [0, 4, 1], [1, 4, 2], [2, 4, 3], [3, 4, 0]  // sides
    ]
);