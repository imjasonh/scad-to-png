# CLAUDE.md - AI Assistant Context

This document provides context for AI assistants (like Claude) working on the scad-to-png project.

## Project Overview

`scad-to-png` is a Node.js CLI tool that converts OpenSCAD files to PNG images without requiring OpenSCAD to be installed. It uses OpenSCAD's WebAssembly (WASM) port for the conversion.

## Key Technical Details

### OpenSCAD WASM Integration

The most challenging part of this project was getting OpenSCAD WASM to work in a headless Node.js environment:

1. **Use the Web Version**: The OpenSCAD WASM build from `openscad.org` has two versions:
   - **Node version** (`OpenSCAD-*-WebAssembly-node.zip`) - Has GUI initialization code that fails in headless environments
   - **Web version** (`OpenSCAD-*-WebAssembly-web.zip`) - Works properly with `noInitialRun: true`

2. **Critical Initialization**: The OpenSCAD module must be initialized as:
   ```javascript
   const instance = await OpenSCAD({
     noInitialRun: true,  // Prevents GUI mode
     wasmBinary: wasmBinary,  // Provide WASM binary directly
     print: (text) => console.log(text),
     printErr: (text) => console.error(text)
   });
   ```

3. **File System**: Uses Emscripten's virtual file system. Files must be written before calling `callMain()`.

4. **Parametric Support**: OpenSCAD parameters can be passed using the `-D` flag, which works identically to the native OpenSCAD CLI. Example: `-D width=30 -D text="Hello"`

### STL Rendering

Since WebGL is not easily available in Node.js, the project implements a software renderer:
- Parses both ASCII and binary STL formats
- Projects 3D triangles to 2D screen coordinates
- Uses painter's algorithm (depth sorting) for rendering
- Simple grayscale shading based on depth

### Common Issues and Solutions

1. **"Requested GUI mode but can't open display!"**
   - This means the wrong WASM build is being used or `noInitialRun` isn't set to `true`
   - Solution: Use the web version of OpenSCAD WASM

2. **Module Loading Issues**
   - The web version expects to fetch the WASM file
   - Solution: Read the WASM file and provide it via `wasmBinary` option

3. **Canvas/GL Dependencies**
   - `node-canvas` requires complex native dependencies
   - Solution: Use `@napi-rs/canvas` which has better cross-platform support

4. **Font Support Issues**
   - OpenSCAD WASM cannot access system fonts in the Node.js environment
   - The `text()` function will fail with "Can't get font" errors
   - Solution: Skip text-based tests or document as a known limitation

5. **README Generation**
   - The tool now automatically generates README.md files with embedded images
   - Each output directory gets a README for easy web viewing on GitHub

## Project Structure

```
scad-to-png/
├── scad-to-png              # Main CLI entry point (ES module)
├── openscad-wrapper.mjs     # Handles OpenSCAD WASM initialization and execution
├── stl-renderer.mjs         # Software renderer for STL to PNG conversion
├── openscad-web/            # OpenSCAD WASM files (web version)
│   ├── openscad.js          # Emscripten-generated JS wrapper
│   └── openscad.wasm        # WebAssembly binary
├── test.scad                # Test file with cube, cylinder hole, and sphere
├── examples/                # Example SCAD files
├── test-suite/              # Comprehensive test suite (40+ test files)
├── generate-test-suite.sh   # Script to regenerate all test outputs
└── output/                  # Generated PNG, STL, and README files
```

## Development Guidelines

### When Modifying OpenSCAD Integration

1. Always use `noInitialRun: true` to prevent GUI initialization
2. The WASM module runs synchronously - use `callMain()` with command-line arguments
3. File paths in the virtual filesystem should use forward slashes
4. Remember to create directories before writing files

### When Modifying STL Rendering

1. The renderer uses a simple projection model - no perspective correction
2. Triangles are sorted by average Z depth (painter's algorithm)
3. Performance could be improved with a proper z-buffer implementation
4. Consider adding anti-aliasing for better quality

### Testing

Test with various OpenSCAD files:
- Simple primitives (cube, sphere, cylinder)
- Boolean operations (union, difference, intersection)
- Complex models with many triangles
- Both ASCII and binary STL outputs
- Parametric models with different parameter values
- Run `./generate-test-suite.sh` to regenerate all test outputs
- Check `test-suite/` directory for comprehensive test coverage

### Future Improvements

1. **Better Rendering**:
   - Implement proper z-buffering
   - Add anti-aliasing
   - Support for colors/materials
   - Perspective-correct rendering

2. **Performance**:
   - Parallel rendering of different views
   - Optimize triangle sorting
   - Cache parsed STL data

3. **Features**:
   - Support for animations
   - Custom camera positions
   - Different output formats (SVG, etc.)
   - Progress indicators for large files

## Debugging Tips

1. **OpenSCAD Errors**: The error messages after "OpenSCAD Error:" are from OpenSCAD's internal logging and can usually be ignored if the conversion succeeds

2. **Checking WASM Loading**: Add console.log in `locateFile` callback to see what files are being requested

3. **STL Parsing Issues**: Write the STL buffer to a file and examine it with a text editor (for ASCII) or hex editor (for binary)

4. **Rendering Issues**: Export projected 2D coordinates to verify the projection math

5. **Test Suite Failures**: Check individual test output directories for error messages and limitation README files

## Dependencies

- `commander`: CLI argument parsing
- `fs-extra`: Enhanced file system operations
- `@napi-rs/canvas`: Cross-platform canvas implementation
- No direct OpenSCAD dependency - uses WASM build

## Known Limitations (from Test Suite)

Based on our comprehensive test suite, the following limitations have been identified:

1. **Text Rendering** (test 09): The `text()` function fails due to font access issues in WASM
2. **Import Functions** (test 36): Cannot import external STL/DXF files in WASM environment
3. **Mesh Deformation** (test 37): Complex mesh operations may produce non-closed meshes
4. **File I/O** (test 38): No support for reading/writing external files
5. **Advanced Features** (test 39): Some experimental features not available in WASM
6. **System Integration** (test 40): No access to system resources or external commands

## Related Projects

- [OpenSCAD WASM](https://github.com/openscad/openscad-wasm) - The WebAssembly port
- [OpenSCAD Playground](https://github.com/openscad/openscad-playground) - Web-based OpenSCAD editor
- Similar tools exist but most require OpenSCAD to be installed