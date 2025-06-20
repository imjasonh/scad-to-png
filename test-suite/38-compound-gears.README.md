# Compound Gears Test - Complex Assembly Limitation

## What This Test Attempts

This test creates a compound planetary gear system with:
- A central sun gear (12 teeth)
- Three planet gears (8 teeth each) arranged at 120° intervals
- An outer ring gear (28 teeth) with internal teeth
- Animation support using the $t variable

## The Limitation Discovered

### Expected Output:
A complete planetary gear system with:
- Visible gear teeth on all components
- Proper meshing between gears
- Clear distinction between sun, planet, and ring gears

### Actual Output:
A simplified circular disk with some holes around the edge - the complex gear geometry is lost.

## The Issue

The complex gear assembly is not being properly rendered. The problems include:

1. **Gear tooth geometry** - The detailed tooth profiles created using cylinders are not visible
2. **Multiple component assembly** - The system of multiple interacting gears is reduced to a simple shape
3. **Internal gear teeth** - The ring gear's internal teeth created by difference() operations are not rendered

## Possible Causes

1. **Complex union/difference operations** - The gear teeth are created by adding/subtracting many cylinders
2. **Multiple overlapping objects** - The planetary gear arrangement might confuse the renderer
3. **Animation variable $t** - Though set to 0 by default, this might affect geometry generation

## Key Takeaway

Complex mechanical assemblies with fine details (like gear teeth) and multiple interacting components may not render correctly. This limits the tool's usefulness for visualizing mechanical designs with precise geometric features.