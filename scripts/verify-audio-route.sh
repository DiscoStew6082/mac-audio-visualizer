#!/bin/bash
# Verify audio routing for ProjectMilkSyphon visualizer setup

echo "=== OUTPUT DEVICES ==="
SwitchAudioSource -a -t output 2>/dev/null || /opt/homebrew/bin/SwitchAudioSource -a -t output

echo ""
echo "=== INPUT DEVICES ==="
SwitchAudioSource -a -t input 2>/dev/null || /opt/homebrew/bin/SwitchAudioSource -a -t input

echo ""
echo "=== BLACKHOLE STATUS ==="
if SwitchAudioSource -a | grep -q "BlackHole"; then
    echo "✅ BlackHole 2ch is registered with macOS audio"
else
    echo "❌ BlackHole 2ch NOT found — run: sudo killall coreaudiod && sleep 4"
fi

echo ""
echo "=== PROCESS CHECK ==="
if pgrep -l ProjectMilkSyphon > /dev/null; then
    echo "✅ ProjectMilkSyphon is running"
else
    echo "⚠️  ProjectMilkSyphon not running — open /Applications/ProjectMilkSyphon.app"
fi

echo ""
echo "=== PRESET COUNT ==="
if [ -d "$HOME/share/projectM" ]; then
    count=$(find "$HOME/share/projectM" -name "*.milk" 2>/dev/null | wc -l)
    echo "✅ $count presets found in ~/share/projectM/"
else
    echo "⚠️  No presets at ~/share/projectM — run install-presets.sh"
fi