#!/bin/bash

# Script to regenerate all example outputs
echo "Regenerating all example outputs..."

# Find all .scad files in examples directory
for scad_file in examples/*.scad; do
    if [ -f "$scad_file" ]; then
        # Get the base name without extension
        base_name=$(basename "$scad_file" .scad)
        
        echo "Processing $scad_file..."
        
        # Generate outputs
        ./scad-to-png "$scad_file" -o "output/$base_name"
        
        if [ $? -eq 0 ]; then
            echo "✓ Generated outputs for $base_name"
        else
            echo "✗ Failed to generate outputs for $base_name"
            exit 1
        fi
    fi
done

echo "All example outputs regenerated successfully!"