# Updating OpenSCAD Dependencies

This guide explains how to update the OpenSCAD WebAssembly files used by scad-to-png.

## Current Version

The project currently uses OpenSCAD WASM files from:
- **Source**: https://files.openscad.org/playground/
- **Version**: OpenSCAD-2025.03.25.wasm24456-WebAssembly-web.zip
- **Location**: `openscad-web/` directory

## Checking for Updates

1. **OpenSCAD Playground Builds**:
   Visit https://files.openscad.org/playground/ to see available WebAssembly builds.
   
2. **OpenSCAD Development Snapshots**:
   Check https://openscad.org/downloads.html#snapshots for the latest development builds.

3. **GitHub Releases**:
   Monitor https://github.com/openscad/openscad-wasm/releases for official releases.

## Update Process

### Step 1: Download the Latest Web Build

```bash
# Navigate to project directory
cd /path/to/scad-to-png

# Download the latest web build (adjust URL as needed)
curl -L -o openscad-web-new.zip "https://files.openscad.org/playground/OpenSCAD-YYYY.MM.DD.wasmXXXXX-WebAssembly-web.zip"
```

**Important**: Always download the **web** version, not the node version. The file should have `-WebAssembly-web.zip` in its name.

### Step 2: Backup Current Version

```bash
# Backup existing files
mv openscad-web openscad-web-backup
```

### Step 3: Extract New Version

```bash
# Extract new files
unzip openscad-web-new.zip -d openscad-web

# Verify contents
ls -la openscad-web/
```

You should see:
- `openscad.js` - The JavaScript wrapper
- `openscad.wasm` - The WebAssembly binary

### Step 4: Test the Update

```bash
# Run test
npm test

# Run examples
npm run example:box
npm run example:gear

# Test with your own files
./scad-to-png your-file.scad
```

### Step 5: Verify Compatibility

Check for:
1. **Successful initialization**: No "GUI mode" errors
2. **STL generation**: Files are created correctly
3. **Rendering**: PNG images are generated properly

### Step 6: Update Documentation

If the update is successful:
1. Update this file with the new version info
2. Update CLAUDE.md if there are any API changes
3. Commit the changes

## Rollback Process

If issues occur:
```bash
# Remove problematic version
rm -rf openscad-web

# Restore backup
mv openscad-web-backup openscad-web

# Test to ensure it works
npm test
```

## Version History

| Date | Version | Notes |
|------|---------|-------|
| 2024-03-25 | OpenSCAD-2025.03.25.wasm24456-WebAssembly-web | Initial version used |

## Troubleshooting Updates

### Common Issues

1. **"Requested GUI mode but can't open display!"**
   - You downloaded the node version instead of the web version
   - Solution: Download the `-WebAssembly-web.zip` file

2. **Module loading errors**
   - The API might have changed
   - Check if initialization parameters need updating in `openscad-wrapper.mjs`

3. **Missing features**
   - New versions might require additional configuration
   - Check the OpenSCAD WASM changelog for breaking changes

### Testing Checklist

- [ ] Basic shapes (cube, sphere, cylinder)
- [ ] Boolean operations (difference, union, intersection)
- [ ] Complex models (gears, threads)
- [ ] Large models (performance test)
- [ ] All 8 view angles generate correctly
- [ ] Error handling still works

## Automated Update Script

Save this as `update-openscad.sh`:

```bash
#!/bin/bash

# Configuration
PLAYGROUND_URL="https://files.openscad.org/playground/"
BACKUP_DIR="openscad-web-backup-$(date +%Y%m%d)"

echo "Checking for latest OpenSCAD WASM build..."

# Get latest web build URL (requires parsing HTML)
# This is a simplified example - you'd need to parse the actual HTML
LATEST_URL="$PLAYGROUND_URL/OpenSCAD-2025.03.25.wasm24456-WebAssembly-web.zip"

echo "Downloading from: $LATEST_URL"

# Backup current version
if [ -d "openscad-web" ]; then
    echo "Backing up current version to $BACKUP_DIR"
    mv openscad-web "$BACKUP_DIR"
fi

# Download and extract
curl -L -o openscad-web-new.zip "$LATEST_URL"
unzip openscad-web-new.zip -d openscad-web

# Test
echo "Running tests..."
npm test

if [ $? -eq 0 ]; then
    echo "Update successful!"
    rm openscad-web-new.zip
else
    echo "Tests failed, rolling back..."
    rm -rf openscad-web
    mv "$BACKUP_DIR" openscad-web
    exit 1
fi
```

## Alternative Sources

1. **Build from source**: Follow instructions at https://github.com/openscad/openscad-wasm
2. **OpenSCAD Playground**: The playground might have newer experimental builds
3. **Custom builds**: You can build with specific features enabled/disabled

## Notes for Maintainers

- Always test with the `test.scad` file first
- Keep at least one backup of a known working version
- Document any API changes in CLAUDE.md
- Update the version history table after successful updates