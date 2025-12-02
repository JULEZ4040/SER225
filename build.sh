#!/bin/bash

set -e

NAME="GOOSEGRAPPLE"

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
CLASSES_DIR="$BUILD_DIR/classes"
JAR_FILE="$PROJECT_DIR/$NAME.jar"

echo "Building $NAME..."

rm -rf "$BUILD_DIR"
mkdir -p "$CLASSES_DIR"
mkdir -p "$BUILD_DIR/META-INF"

echo "Compiling Java sources..."
find "$PROJECT_DIR/src" -name "*.java" | xargs javac -d "$CLASSES_DIR"

echo "Creating manifest..."
printf 'Manifest-Version: 1.0\nMain-Class: Game.Game\n' > "$BUILD_DIR/META-INF/MANIFEST.MF"

echo "Copying resources..."
cp -r "$PROJECT_DIR/Resources/"* "$CLASSES_DIR/"
cp "$PROJECT_DIR/MapFiles/"* "$CLASSES_DIR/" 2>/dev/null || true
cp "$PROJECT_DIR/levels.json" "$CLASSES_DIR/" 2>/dev/null || true
cp "$PROJECT_DIR/speedrun_records.json" "$CLASSES_DIR/" 2>/dev/null || true

echo "Creating JAR..."
cd "$CLASSES_DIR"
jar cfm "$JAR_FILE" "$BUILD_DIR/META-INF/MANIFEST.MF" .

echo "Build complete: $JAR_FILE"
echo "Run with: java -jar $NAME.jar"
