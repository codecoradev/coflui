#!/usr/bin/env bash
#
# Build the coflui example app for web (release mode).
#
# Why --no-tree-shake-icons?
#   IconResolver (lib/src/dynamic/resolvers/icon_resolver.dart) creates IconData
#   instances at RUNTIME from JSON strings. Flutter's web tree-shaker requires
#   all IconData references to be compile-time constants — so it fails without
#   this flag. This is an inherent trade-off of dynamic icon resolution.
#
# Usage:
#   ./tool/build_web.sh            # build only → example/build/web
#   ./tool/build_web.sh --serve    # build + serve locally on :5678 (LAN-accessible)
set -euo pipefail

cd "$(dirname "$0")/.."

EXAMPLE_DIR="example"
BUILD_DIR="$EXAMPLE_DIR/build/web"

echo "🔨 Building coflui example (web release)…"
cd "$EXAMPLE_DIR"
flutter build web --release --no-tree-shake-icons
cd - >/dev/null

echo "✅ Build complete → $BUILD_DIR"

if [[ "${1:-}" == "--serve" ]]; then
  PORT="${2:-5678}"
  echo "🌐 Serving on http://0.0.0.0:$PORT (LAN-accessible)"
  echo "   Local: http://localhost:$PORT"
  cd "$BUILD_DIR"
  python3 -m http.server "$PORT" --bind 0.0.0.0
fi
