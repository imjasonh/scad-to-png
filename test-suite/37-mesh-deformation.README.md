# Mesh Deformation Test - Limitation Documentation

## What This Test Attempts

This test tries to create a wave-patterned surface mesh with thickness - essentially a wavy sheet with top and bottom surfaces connected by edges.

## The Limitation Discovered

### What went wrong:
1. **OpenSCAD requires closed meshes** - A polyhedron must be a completely closed 3D solid with no gaps or holes
2. **Our initial approach** used `polyhedron()` to create just the top surface (like a sheet of paper), which is not a valid 3D solid
3. **The difference operation failed** because you can't subtract from an unclosed mesh

### Why the current fix is incomplete:
Even after adding:
- A bottom surface (offset from the top)
- Edge connectors using `hull()` operations

The result shows only the edge connectors, not the complete wavy surfaces. This happens because:
- The separate polyhedrons (top and bottom) are still treated as individual unclosed meshes
- OpenSCAD can't properly merge them into a single closed solid
- Only the `hull()` operations create valid geometry

## The Fundamental Limitation

**OpenSCAD's `polyhedron()` requires you to define ALL faces of a closed 3D object in a single call**. You cannot:
- Build a complex mesh by combining multiple polyhedrons
- Create open surfaces and close them later
- Use boolean operations on unclosed meshes

## Correct Approach

To properly create this mesh, you would need to create a single polyhedron with:
- All vertices (top AND bottom points)
- All faces properly defined (top, bottom, and all side faces)
- Correct face winding (counterclockwise when viewed from outside)

This is significantly more complex because you need to:
1. Calculate all edge vertices
2. Define quadrilateral faces for all sides
3. Ensure proper vertex ordering for each face
4. Handle the complexity of connecting a grid's edges

## Key Takeaway

This limitation shows that while OpenSCAD is excellent for CSG (Constructive Solid Geometry) operations on primitive shapes, creating complex custom meshes requires careful attention to mesh topology. Each polyhedron must be completely self-contained and closed.