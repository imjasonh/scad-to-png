// Quick test to see what the module exports
const Module = require('./openscad-wasm-dist/openscad.js');
console.log('Module type:', typeof Module);
console.log('Module keys:', Object.keys(Module).slice(0, 10));
console.log('Module.callMain:', typeof Module.callMain);
console.log('Module.FS:', typeof Module.FS);