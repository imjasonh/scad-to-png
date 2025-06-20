// Mesh deformation - wave pattern on a grid
size = 40;
resolution = 30;
wave_amplitude = 3;
wave_frequency = 2;

// Generate deformed mesh points
points = [
    for (x = [0:resolution])
        for (y = [0:resolution])
            let (xp = (x / resolution - 0.5) * size)
            let (yp = (y / resolution - 0.5) * size)
            let (zp = wave_amplitude * sin(wave_frequency * 360 * x / resolution) * 
                      cos(wave_frequency * 360 * y / resolution))
            [xp, yp, zp]
];

// Generate quad faces
faces = [
    for (x = [0:resolution-1])
        for (y = [0:resolution-1])
            let (base = x * (resolution + 1) + y)
            [base, base + 1, base + resolution + 2, base + resolution + 1]
];

// Create mesh with thickness by creating top and bottom surfaces
module wave_surface() {
    // Top surface
    polyhedron(points = points, faces = faces);
    
    // Bottom surface (offset down)
    bottom_points = [
        for (p = points) [p.x, p.y, p.z - 2]
    ];
    
    // Bottom faces (reversed winding)
    bottom_faces = [
        for (face = faces) [face[3], face[2], face[1], face[0]]
    ];
    
    polyhedron(points = bottom_points, faces = bottom_faces);
    
    // Side walls to close the mesh
    side_resolution = resolution;
    for (i = [0:side_resolution-1]) {
        // Front edge
        hull() {
            translate(points[i])
                sphere(0.1, $fn = 4);
            translate(points[i+1])
                sphere(0.1, $fn = 4);
            translate(bottom_points[i])
                sphere(0.1, $fn = 4);
            translate(bottom_points[i+1])
                sphere(0.1, $fn = 4);
        }
        
        // Back edge
        j = resolution * (resolution + 1) + i;
        hull() {
            translate(points[j])
                sphere(0.1, $fn = 4);
            translate(points[j+1])
                sphere(0.1, $fn = 4);
            translate(bottom_points[j])
                sphere(0.1, $fn = 4);
            translate(bottom_points[j+1])
                sphere(0.1, $fn = 4);
        }
    }
}

wave_surface();