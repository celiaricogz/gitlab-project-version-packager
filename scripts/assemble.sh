#!/bin/bash
set -euo pipefail

# Input variables
PACKAGE_NAME="$1"
PACKAGE_VERSION="$2"
shift 2
MODULE_PATHS=("$@")  # rest of the arguments: module paths

echo "Assembling package: ${PACKAGE_NAME}-${PACKAGE_VERSION}"
BUILD_DIR="build/${PACKAGE_NAME}-${PACKAGE_VERSION}"
mkdir -p "$BUILD_DIR"

# Copy each module to the build directory
for module_path in "${MODULE_PATHS[@]}"; do
    name="$(basename "$module_path")"
    echo "Copying module: $name"
    cp -r "$module_path" "$BUILD_DIR/$name"
done

# Optional manifest
echo "Included modules:" > "$BUILD_DIR/manifest.txt"
for module_path in "${MODULE_PATHS[@]}"; do
    name="$(basename "$module_path")"
    echo "- $name" >> "$BUILD_DIR/manifest.txt"
done

# Compress
cd build
zip -r "../${PACKAGE_NAME}-${PACKAGE_VERSION}.zip" "${PACKAGE_NAME}-${PACKAGE_VERSION}"
cd ..

echo "Package created: ${PACKAGE_NAME}-${PACKAGE_VERSION}.zip"
