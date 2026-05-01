#!/bin/bash
# Download and install projectM MilkDrop presets for ProjectMilkSyphon
set -e

DEST="$HOME/share/projectM"
mkdir -p "$DEST"

echo "Downloading preset pack (~10MB)..."
curl -L -o /tmp/presets.tar.gz \
  "https://github.com/projectM-visualizer/presets-cream-of-the-crop/archive/master.tar.gz"

echo "Extracting presets..."
tar -xzf /tmp/presets.tar.gz -C "$DEST"
mv "$DEST/presets-cream-of-the-crop-master"/* "$DEST/" 2>/dev/null || true
rm -rf "$DEST/presets-cream-of-the-crop-master"

echo "Downloading texture pack (~3MB)..."
curl -L -o /tmp/textures.tar.gz \
  "https://github.com/projectM-visualizer/presets-milkdrop-texture-pack/archive/master.tar.gz"

echo "Extracting textures..."
tar -xzf /tmp/textures.tar.gz -C "$DEST"
cp -R "$DEST/presets-milkdrop-texture-pack-master/textures" "$DEST/"
rm -rf "$DEST/presets-milkdrop-texture-pack-master"

# Symlink to standard location
mkdir -p "$HOME/.local/share"
ln -sf "$DEST" "$HOME/.local/share/projectM"

echo ""
echo "Done! Presets installed at: $DEST"
find "$DEST" -name "*.milk" | wc -l | xargs echo "Milk files:"
ls "$DEST"