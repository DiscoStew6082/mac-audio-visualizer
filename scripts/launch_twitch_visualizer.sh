#!/bin/bash
# Launch a Twitch stream + ProjectMilkSyphon visualizer
# Usage: ./launch_twitch_visualizer.sh <channel> [audio_device]
#   channel     — Twitch username or channel name (e.g. your_channel_name)
#   audio_device — optional BlackHole device name (default: BlackHole 2ch)
set -e

CHANNEL="${1:-}"
AUDIO_DEVICE="${2:-BlackHole 2ch}"

if [ -z "$CHANNEL" ]; then
    echo "Usage: $0 <twitch_channel> [audio_device]"
    echo "Example: $0 your_channel_name"
    exit 1
fi

# Verify BlackHole is registered
if ! SwitchAudioSource -a | grep -q "$AUDIO_DEVICE"; then
    echo "❌ Audio device '$AUDIO_DEVICE' not found."
    echo ""
    echo "Available output devices:"
    SwitchAudioSource -a -t output
    exit 1
fi

# Verify ProjectMilkSyphon is installed
if [ ! -d "/Applications/ProjectMilkSyphon.app" ]; then
    echo "❌ ProjectMilkSyphon not found at /Applications/"
    echo "Download from: https://vdmx.vidvox.net/blog/projectmilksyphon"
    exit 1
fi

# Verify presets exist
PRESET_COUNT=$(find "$HOME/share/projectM" -name "*.milk" 2>/dev/null | wc -l | tr -d ' ')
if [ "$PRESET_COUNT" -eq 0 ]; then
    echo "⚠️  No MilkDrop presets found. Run ./scripts/install-presets.sh first."
    echo ""
    read -p "Continue anyway? (y/N) " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        exit 1
    fi
fi

# Open Twitch stream in default browser
TWITCH_URL="https://twitch.tv/$CHANNEL"
echo "Opening $TWITCH_URL ..."
open "$TWITCH_URL"

# Wait for browser to start playing
sleep 3

# Launch ProjectMilkSyphon if not already running
if ! pgrep -l ProjectMilkSyphon > /dev/null; then
    echo "Starting ProjectMilkSyphon..."
    open "/Applications/ProjectMilkSyphon.app"
    sleep 2
else
    echo "ProjectMilkSyphon already running."
fi

echo ""
echo "✅ Setup complete:"
echo "   Channel: $TWITCH_URL (playing in browser)"
echo "   Visualizer audio source: $AUDIO_DEVICE"
echo "   Presets loaded: $PRESET_COUNT"
echo ""
echo "In ProjectMilkSyphon, make sure Audio Source is set to '$AUDIO_DEVICE'."