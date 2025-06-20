// Geodesic sphere using icosahedron subdivision
phi = (1 + sqrt(5)) / 2;

// Icosahedron vertices
icosa_vertices = [
    [-1, phi, 0], [1, phi, 0], [-1, -phi, 0], [1, -phi, 0],
    [0, -1, phi], [0, 1, phi], [0, -1, -phi], [0, 1, -phi],
    [phi, 0, -1], [phi, 0, 1], [-phi, 0, -1], [-phi, 0, 1]
];

// Normalize to unit sphere
vertices = [for (v = icosa_vertices) v / norm(v) * 20];

// Icosahedron faces
faces = [
    [0, 11, 5], [0, 5, 1], [0, 1, 7], [0, 7, 10], [0, 10, 11],
    [1, 5, 9], [5, 11, 4], [11, 10, 2], [10, 7, 6], [7, 1, 8],
    [3, 9, 4], [3, 4, 2], [3, 2, 6], [3, 6, 8], [3, 8, 9],
    [4, 9, 5], [2, 4, 11], [6, 2, 10], [8, 6, 7], [9, 8, 1]
];

// Create geodesic sphere frame
for (face = faces) {
    for (i = [0:2]) {
        hull() {
            translate(vertices[face[i]])
                sphere(r = 1, $fn = 10);
            translate(vertices[face[(i + 1) % 3]])
                sphere(r = 1, $fn = 10);
        }
    }
}