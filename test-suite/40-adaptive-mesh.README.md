# Adaptive Mesh Test - Mesh Refinement Limitation

## What This Test Attempts

This test tries to demonstrate adaptive mesh refinement by creating:
- A sphere with varying levels of detail ($fn values)
- High detail (80 facets) on the front hemisphere
- Medium detail (40 facets) on the sides
- Low detail (20 facets) on the back
- Additional small sphere features requiring high detail

## The Limitation Discovered

### Expected Output:
A sphere with visibly different mesh densities:
- Smooth, high-resolution front
- Medium-resolution sides
- Noticeably faceted back
- 6 small spheres around the equator as detail features

### Actual Output:
A uniform sphere with consistent mesh density throughout and missing surface features.

## The Issue

The adaptive mesh concept fails because:

1. **Boolean operations merge meshes** - When using intersection() to combine different resolution spheres, OpenSCAD appears to unify the mesh
2. **Missing surface features** - The 6 small spheres that should appear around the equator are not visible
3. **Uniform tessellation** - The final rendered sphere shows uniform faceting rather than variable detail

## Why This Approach Doesn't Work

1. **OpenSCAD's mesh handling** - OpenSCAD internally converts all geometry to a unified mesh representation
2. **CSG operations** - Boolean operations don't preserve the original mesh resolutions of input objects
3. **STL export** - The STL format itself doesn't support variable mesh density in a single object

## Conceptual Issue

"Adaptive mesh refinement" is a rendering/modeling concept that doesn't align with OpenSCAD's CSG-based approach. OpenSCAD thinks in terms of solid geometry operations, not mesh topology.

## Key Takeaway

OpenSCAD doesn't support true adaptive mesh refinement. All geometry is converted to a uniform mesh representation during processing. This is a fundamental limitation of the CSG approach compared to mesh-based modeling tools.