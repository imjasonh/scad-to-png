// Gyroid minimal surface approximation
module gyroid_unit(size, thickness, resolution = 20) {
    // Generate gyroid surface approximation using implicit function
    // f(x,y,z) = sin(x)cos(y) + sin(y)cos(z) + sin(z)cos(x) = 0
    
    scale = 2 * PI / size;
    
    points = [];
    faces = [];
    
    // Sample the implicit surface
    for (x = [0:resolution]) {
        for (y = [0:resolution]) {
            for (z = [0:resolution]) {
                xp = (x / resolution - 0.5) * size;
                yp = (y / resolution - 0.5) * size;
                zp = (z / resolution - 0.5) * size;
                
                // Evaluate implicit function
                val = sin(xp * scale * 180/PI) * cos(yp * scale * 180/PI) +
                      sin(yp * scale * 180/PI) * cos(zp * scale * 180/PI) +
                      sin(zp * scale * 180/PI) * cos(xp * scale * 180/PI);
                
                // Create small cubes near the surface
                if (abs(val) < thickness) {
                    translate([xp, yp, zp])
                        cube(size/resolution, center = true);
                }
            }
        }
    }
}

gyroid_unit(30, 0.3, 25);