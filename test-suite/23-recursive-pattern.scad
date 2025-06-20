// Recursive cubic pattern - Menger sponge iteration
module menger_iteration(size, level) {
    if (level <= 0) {
        cube(size, center = true);
    } else {
        new_size = size / 3;
        for (x = [-1, 0, 1]) {
            for (y = [-1, 0, 1]) {
                for (z = [-1, 0, 1]) {
                    // Skip the center and face centers
                    if ((abs(x) + abs(y) + abs(z)) > 1) {
                        translate([x * new_size, y * new_size, z * new_size])
                            menger_iteration(new_size, level - 1);
                    }
                }
            }
        }
    }
}

menger_iteration(30, 2);