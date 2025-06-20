import { createCanvas } from '@napi-rs/canvas';

// Simple STL parser
function parseSTL(buffer) {
  const dataView = new DataView(buffer.buffer || buffer);
  const isASCII = new TextDecoder().decode(buffer.slice(0, 6)) === 'solid ';
  
  if (isASCII) {
    return parseASCIISTL(new TextDecoder().decode(buffer));
  } else {
    return parseBinarySTL(dataView);
  }
}

function parseASCIISTL(text) {
  const triangles = [];
  const lines = text.split('\n');
  let i = 0;
  
  while (i < lines.length) {
    const line = lines[i].trim();
    if (line.startsWith('facet normal')) {
      const vertices = [];
      i += 2; // skip 'outer loop'
      
      for (let j = 0; j < 3; j++) {
        const vertexLine = lines[i + j].trim();
        const coords = vertexLine.split(/\s+/).slice(1).map(parseFloat);
        vertices.push(coords);
      }
      
      triangles.push(vertices);
      i += 5; // skip to next facet
    } else {
      i++;
    }
  }
  
  return triangles;
}

function parseBinarySTL(dataView) {
  const triangles = [];
  const triangleCount = dataView.getUint32(80, true);
  let offset = 84;
  
  for (let i = 0; i < triangleCount; i++) {
    // Skip normal (12 bytes)
    offset += 12;
    
    const vertices = [];
    for (let j = 0; j < 3; j++) {
      vertices.push([
        dataView.getFloat32(offset, true),
        dataView.getFloat32(offset + 4, true),
        dataView.getFloat32(offset + 8, true)
      ]);
      offset += 12;
    }
    
    triangles.push(vertices);
    offset += 2; // Skip attribute byte count
  }
  
  return triangles;
}

// 3D to 2D projection
function project3Dto2D(vertex, camera, width, height) {
  // Apply camera transformation
  const dx = vertex[0] - camera.target[0];
  const dy = vertex[1] - camera.target[1];
  const dz = vertex[2] - camera.target[2];
  
  // Rotate around Y axis (horizontal rotation)
  const cosY = Math.cos(camera.rotation[1]);
  const sinY = Math.sin(camera.rotation[1]);
  const x1 = dx * cosY - dz * sinY;
  const z1 = dx * sinY + dz * cosY;
  
  // Rotate around X axis (vertical rotation)
  const cosX = Math.cos(camera.rotation[0]);
  const sinX = Math.sin(camera.rotation[0]);
  const y1 = dy * cosX - z1 * sinX;
  const z2 = dy * sinX + z1 * cosX + camera.distance;
  
  // Perspective projection
  if (z2 <= 0) return null;
  
  const scale = camera.scale / z2;
  const x2d = x1 * scale + width / 2;
  const y2d = -y1 * scale + height / 2;
  
  return [x2d, y2d, z2];
}

// Simple z-buffer renderer
export function renderSTL(stlBuffer, viewConfig, width, height) {
  const canvas = createCanvas(width, height);
  const ctx = canvas.getContext('2d');
  
  // Parse STL
  const triangles = parseSTL(stlBuffer);
  if (triangles.length === 0) {
    throw new Error('No triangles found in STL');
  }
  
  // Calculate bounds
  let minX = Infinity, minY = Infinity, minZ = Infinity;
  let maxX = -Infinity, maxY = -Infinity, maxZ = -Infinity;
  
  triangles.forEach(triangle => {
    triangle.forEach(vertex => {
      minX = Math.min(minX, vertex[0]);
      minY = Math.min(minY, vertex[1]);
      minZ = Math.min(minZ, vertex[2]);
      maxX = Math.max(maxX, vertex[0]);
      maxY = Math.max(maxY, vertex[1]);
      maxZ = Math.max(maxZ, vertex[2]);
    });
  });
  
  const centerX = (minX + maxX) / 2;
  const centerY = (minY + maxY) / 2;
  const centerZ = (minZ + maxZ) / 2;
  const size = Math.max(maxX - minX, maxY - minY, maxZ - minZ);
  
  // Set up camera based on view config
  const camera = {
    target: [centerX, centerY, centerZ],
    distance: size * viewConfig.distance * 2,
    scale: Math.min(width, height) * 0.8,
    rotation: [
      Math.atan2(viewConfig.position[1], Math.sqrt(viewConfig.position[0]**2 + viewConfig.position[2]**2)),
      Math.atan2(viewConfig.position[0], viewConfig.position[2])
    ]
  };
  
  // Clear canvas
  ctx.fillStyle = '#f0f0f0';
  ctx.fillRect(0, 0, width, height);
  
  // Sort triangles by average Z (painter's algorithm)
  const projectedTriangles = triangles.map(triangle => {
    const projected = triangle.map(v => project3Dto2D(v, camera, width, height));
    if (projected.some(p => p === null)) return null;
    
    const avgZ = projected.reduce((sum, p) => sum + p[2], 0) / 3;
    return { triangle, projected, avgZ };
  }).filter(t => t !== null);
  
  projectedTriangles.sort((a, b) => b.avgZ - a.avgZ);
  
  // Render triangles
  projectedTriangles.forEach(({ projected }) => {
    ctx.beginPath();
    ctx.moveTo(projected[0][0], projected[0][1]);
    ctx.lineTo(projected[1][0], projected[1][1]);
    ctx.lineTo(projected[2][0], projected[2][1]);
    ctx.closePath();
    
    // Simple shading based on Z depth
    const avgZ = (projected[0][2] + projected[1][2] + projected[2][2]) / 3;
    const brightness = Math.max(0.3, Math.min(1, 1 - (avgZ - camera.distance) / (size * 2)));
    const color = Math.floor(brightness * 200);
    
    ctx.fillStyle = `rgb(${color}, ${color}, ${color + 20})`;
    ctx.fill();
    ctx.strokeStyle = `rgb(${color - 20}, ${color - 20}, ${color})`;
    ctx.lineWidth = 0.5;
    ctx.stroke();
  });
  
  return canvas.toBuffer('image/png');
}