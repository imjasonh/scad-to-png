// Parametric star
points = 5;
outer_radius = 20;
inner_radius = 8;

module star(points, outer, inner) {
    angle = 360 / points;
    
    polygon(points = [
        for (i = [0:points-1]) each [
            [outer * cos(i * angle), outer * sin(i * angle)],
            [inner * cos((i + 0.5) * angle), inner * sin((i + 0.5) * angle)]
        ]
    ]);
}

linear_extrude(height = 10)
    star(points, outer_radius, inner_radius);