import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Read arguments
const inputFile = process.argv[2];
const outputFile = process.argv[3];
const additionalArgs = process.argv.slice(4);

if (!inputFile || !outputFile) {
  console.error('Usage: node openscad-wrapper.mjs <input.scad> <output.stl> [openscad args...]');
  process.exit(1);
}

// Read SCAD content
const scadContent = fs.readFileSync(inputFile, 'utf8');
console.log('Read SCAD file, length:', scadContent.length);

// Read the WASM file
const wasmPath = path.join(__dirname, 'openscad-web', 'openscad.wasm');
const wasmBinary = fs.readFileSync(wasmPath);
console.log('Loaded WASM binary, size:', wasmBinary.length);

// Polyfill browser environment for the web version
global.window = global;
global.location = { href: 'file://' + __dirname + '/' };

// Import the OpenSCAD module dynamically
console.log('Loading OpenSCAD web module...');
const OpenSCAD = (await import('./openscad-web/openscad.js')).default;

try {
  console.log('Initializing OpenSCAD...');
  
  // Initialize OpenSCAD with noInitialRun to prevent GUI mode
  const instance = await OpenSCAD({
    noInitialRun: true,
    wasmBinary: wasmBinary, // Provide the WASM binary directly
    locateFile: (filename) => {
      // This shouldn't be called now that we provide wasmBinary
      console.log('locateFile called for:', filename);
      return filename;
    },
    print: (text) => console.log('OpenSCAD:', text),
    printErr: (text) => console.error('OpenSCAD Error:', text)
  });
  
  console.log('OpenSCAD initialized successfully');
  
  // Create working directory
  try {
    instance.FS.mkdir('/tmp');
  } catch (e) {
    // Directory might already exist
  }
  
  // Write input file
  instance.FS.writeFile('/tmp/input.scad', scadContent);
  console.log('Wrote input file to virtual filesystem');
  
  // Run OpenSCAD
  console.log('Running OpenSCAD...');
  const args = ['/tmp/input.scad', '-o', '/tmp/output.stl', '--export-format=asciistl', ...additionalArgs];
  
  if (additionalArgs.length > 0) {
    console.log('With parameters:', additionalArgs.join(' '));
  }
  
  const exitCode = instance.callMain(args);
  
  console.log('OpenSCAD completed with exit code:', exitCode);
  
  if (exitCode === 0) {
    // Read output
    const stlData = instance.FS.readFile('/tmp/output.stl');
    console.log('Generated STL, size:', stlData.length);
    
    // Write to file
    fs.writeFileSync(outputFile, Buffer.from(stlData));
    console.log('Wrote STL file successfully');
    process.exit(0);
  } else {
    console.error('OpenSCAD failed with exit code:', exitCode);
    
    // List files for debugging
    try {
      const files = instance.FS.readdir('/tmp');
      console.log('Files in /tmp:', files);
    } catch (e) {
      console.error('Could not list files:', e.message);
    }
    
    process.exit(1);
  }
} catch (e) {
  console.error('Error:', e.message);
  if (e.stack) console.error(e.stack);
  process.exit(1);
}