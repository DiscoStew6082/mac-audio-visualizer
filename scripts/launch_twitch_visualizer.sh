#!/bin/bash
# Open a Twitch channel and request a ProjectMilkSyphon launch.
# Usage: ./launch_twitch_visualizer.sh <channel> [audio_device]
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=audio-common.sh
source "$SCRIPT_DIR/audio-common.sh"

CHANNEL="${1:-}"
AUDIO_DEVICE="${2:-BlackHole 2ch}"
APP_PATH="${PROJECT_MILK_APP:-/Applications/ProjectMilkSyphon.app}"
if [[ ! "$CHANNEL" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Usage: $0 <twitch_channel> [audio_device]" >&2
    exit 1
fi
resolve_switch_audio_source
if ! INPUT_DEVICES=$("$SWITCH_AUDIO_SOURCE" -a -t input); then
    echo "Could not list audio input devices." >&2
    exit 1
fi
if ! has_audio_device "$INPUT_DEVICES" "$AUDIO_DEVICE"; then
    printf "Audio input device '%s' not found. Available inputs:\n%s\n" "$AUDIO_DEVICE" "$INPUT_DEVICES" >&2
    exit 1
fi
if [ ! -d "$APP_PATH" ]; then
    echo "ProjectMilkSyphon not found at $APP_PATH" >&2
    echo "Download from: https://vdmx.vidvox.net/blog/projectmilksyphon" >&2
    exit 1
fi
command -v open >/dev/null || { echo "The macOS open command is unavailable." >&2; exit 1; }
PRESET_COUNT=$(count_presets "$HOME/share/projectM")
if [ "$PRESET_COUNT" -eq 0 ]; then
    echo "No MilkDrop preset files found. Run ./scripts/install-presets.sh first."
    read -r -p "Continue anyway? (y/N) " confirm
    if [ "$confirm" != y ] && [ "$confirm" != Y ]; then
        exit 1
    fi
fi

TWITCH_URL="https://twitch.tv/$CHANNEL"
echo "Requesting browser open: $TWITCH_URL"
open "$TWITCH_URL"
if pgrep -x ProjectMilkSyphon >/dev/null; then
    echo "ProjectMilkSyphon process is running."
else
    open "$APP_PATH"
    echo "ProjectMilkSyphon launch requested."
fi
printf '\nChannel URL opened: %s\nAudio input available: %s\nPreset files available: %s\n' "$TWITCH_URL" "$AUDIO_DEVICE" "$PRESET_COUNT"
echo "Playback and visualizer routing have not been verified."
printf "Start playback in the browser and select '%s' as ProjectMilkSyphon's Audio Source.\n" "$AUDIO_DEVICE"
echo "Select the preset folder and confirm you can hear audio and see the visualizer react."
