# Boolean Art Test - Rendering Limitation

## What This Test Attempts

This test creates a complex artistic sculpture using multiple boolean operations:
- Starting with a sphere
- Subtracting multiple rotating cubes at various angles
- Subtracting cylinders in 6 different directions
- Adding intersecting tori

## The Limitation Discovered

### Expected Output:
A sculptural form with:
- Multiple angular cuts through the sphere from the subtracted cubes
- Cylindrical holes in 6 directions creating a complex pattern
- Intersecting tori visible as raised features

### Actual Output:
A simple sphere with minimal visible modifications - only one or two small holes are visible in some views.

## The Issue

The complex boolean operations are not being properly rendered. This appears to be a limitation in either:

1. **OpenSCAD WASM's handling of complex CSG operations** - Multiple nested difference() and intersection() operations may not be fully evaluated
2. **STL generation** - The complex geometry might be generated but not properly exported to STL
3. **Rendering pipeline** - The STL might contain the correct geometry but our renderer cannot handle the complexity

## Key Takeaway

While simple boolean operations work well (as seen in earlier tests), combining many boolean operations in a single model can fail to render properly. This limits the complexity of CSG-based artistic or sculptural designs that can be visualized with this tool.