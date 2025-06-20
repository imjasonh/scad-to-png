#!/bin/bash

# Generate outputs for all test suite files
echo "Generating outputs for test suite..."

for scad_file in test-suite/*.scad; do
    if [ -f "$scad_file" ]; then
        base_name=$(basename "$scad_file" .scad)
        echo "Processing $base_name..."

        time ./scad-to-png "$scad_file" -o "output/test-suite/$base_name" || {
            echo "Failed to process $base_name"
        }
    fi
done

echo "Test suite generation complete!"
