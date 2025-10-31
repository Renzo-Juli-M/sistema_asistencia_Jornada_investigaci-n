#!/bin/bash

echo "=========================================="
echo "Building Sistema de Asistencia Frontend"
echo "=========================================="
echo ""

echo "Step 1: Getting dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "Error: Failed to get dependencies"
    exit 1
fi

echo ""
echo "Step 2: Running code generation..."
echo "This will generate:"
echo "  - JSON serialization code (.g.dart files)"
echo "  - Injectable dependency injection code (injection.config.dart)"
echo ""

flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -ne 0 ]; then
    echo "Error: Failed to run code generation"
    exit 1
fi

echo ""
echo "=========================================="
echo "Build completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Update the API base URL in lib/core/network/network_module.dart"
echo "2. Run the app with: flutter run"
echo ""
