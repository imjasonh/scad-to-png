# scad-to-png

A CLI tool that converts OpenSCAD files to PNG images from multiple viewpoints without requiring OpenSCAD to be installed. This tool uses OpenSCAD WASM to convert .scad files to STL, then renders the STL to PNG images from 8 different angles.

## Features

- **No OpenSCAD installation required** - Uses OpenSCAD WebAssembly (WASM) for conversion
- **Multiple viewpoints** - Generates 8 PNG images: front, back, left, right, top, bottom, and two isometric views
- **Headless operation** - Works in pure Node.js without requiring a display
- **Software rendering** - Custom STL renderer that doesn't require WebGL
- **AI-friendly** - Designed for use in feedback loops with AI agents generating OpenSCAD code

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/scad-to-png.git
cd scad-to-png

# Install dependencies
npm install

# Make the CLI executable
chmod +x scad-to-png
```

## Usage

```bash
./scad-to-png input.scad
```

This will:
1. Convert `input.scad` to STL using OpenSCAD WASM
2. Render the STL from 8 different viewpoints
3. Save PNG images to the `output/` directory

### Options

```bash
./scad-to-png <input> [options]

Options:
  -o, --output <dir>          Output directory (default: "output")
  -w, --width <width>         Image width (default: "800")
  -h, --height <height>       Image height (default: "600")
  -D, --define <params...>    OpenSCAD parameters (e.g., -D size=10 -D holes=true)
  --help                      Display help
```

### Example

```bash
# Convert a simple box
./scad-to-png examples/simple-box.scad

# Specify custom output directory and size
./scad-to-png my-model.scad -o renders -w 1024 -h 768

# Use parametric models with custom values
./scad-to-png examples/parametric-box.scad -D width=30 -D height=20 -D has_lid=true

# Multiple parameters with different types
./scad-to-png model.scad -D size=25 -D text=\"Hello\" -D show_debug=false
```

## Output

The tool generates 8 PNG images and an STL file in the output directory:
- `<filename>.stl` - The 3D model in STL format
- `front.png` - Front view
- `back.png` - Back view
- `left.png` - Left side view
- `right.png` - Right side view
- `top.png` - Top view
- `bottom.png` - Bottom view
- `isometric.png` - Isometric view
- `isometric-alt.png` - Alternative isometric view

## How It Works

1. **OpenSCAD WASM**: The tool uses the WebAssembly version of OpenSCAD to convert .scad files to STL format without requiring OpenSCAD to be installed
2. **STL Parsing**: Parses both ASCII and binary STL formats
3. **Software Rendering**: Implements a custom 3D renderer that projects triangles to 2D and uses a painter's algorithm for depth sorting
4. **Multiple Views**: Positions a virtual camera at different angles to capture all sides of the model

## Requirements

- Node.js 18+ (with ES modules support)
- npm or yarn

## Development

### Pre-commit Hook

To set up automatic regeneration of example outputs before commits:

```bash
# Install pre-commit (if not already installed)
pip install pre-commit
# or
brew install pre-commit

# Install the git hook scripts
pre-commit install
```

This will run `regenerate-examples.sh` before each commit to ensure that example outputs in the `output/` directory stay in sync with their source files.

## Architecture

```
scad-to-png
├── scad-to-png          # Main CLI script
├── openscad-wrapper.mjs # OpenSCAD WASM wrapper
├── stl-renderer.mjs     # STL to PNG renderer
└── openscad-web/        # OpenSCAD WASM files
    ├── openscad.js
    └── openscad.wasm
```

## Limitations

- The software renderer is basic and may not handle very complex models well
- Large STL files may take longer to render
- No support for materials or textures (uses simple grayscale shading)
- OpenSCAD WASM may have different behavior than native OpenSCAD for some edge cases

## Use Cases

This tool is particularly useful for:
- **AI Development**: Testing AI-generated OpenSCAD code by visualizing the output
- **CI/CD**: Automated testing of OpenSCAD models in headless environments
- **Documentation**: Generating previews of OpenSCAD models for documentation
- **Batch Processing**: Converting multiple OpenSCAD files to images

## Maintenance

### Updating OpenSCAD WASM

See [UPDATING.md](UPDATING.md) for instructions on how to update the OpenSCAD WebAssembly files to newer versions.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details

## Acknowledgments

- OpenSCAD team for the WebAssembly port
- The OpenSCAD Playground project for inspiration on WASM usage