#!/bin/bash
# Inspect available audio devices, process, and files; does not change routing.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=audio-common.sh
source "$SCRIPT_DIR/audio-common.sh"
AUDIO_DEVICE="${1:-BlackHole 2ch}"
resolve_switch_audio_source

# Resolve once and use the same binary for every diagnostic.
OUTPUT_DEVICES=$("$SWITCH_AUDIO_SOURCE" -a -t output)
INPUT_DEVICES=$("$SWITCH_AUDIO_SOURCE" -a -t input)
printf '=== OUTPUT DEVICES ===\n%s\n\n=== INPUT DEVICES ===\n%s\n' "$OUTPUT_DEVICES" "$INPUT_DEVICES"
status=0
printf '\n=== REQUESTED INPUT ===\n'
if has_audio_device "$INPUT_DEVICES" "$AUDIO_DEVICE"; then
    printf "Audio input '%s' is available.\n" "$AUDIO_DEVICE"
else
    printf "Audio input '%s' was not found.\n" "$AUDIO_DEVICE" >&2
    status=1
fi
printf '\n=== PROCESS CHECK ===\n'
if pgrep -x ProjectMilkSyphon >/dev/null; then
    echo "ProjectMilkSyphon process is running."
else
    echo "ProjectMilkSyphon process was not found."
    status=1
fi
printf '\n=== PRESET COUNT ===\n'
count=$(count_presets "$HOME/share/projectM")
printf '%s preset files available in ~/share/projectM/\n' "$count"
if [ "$count" -eq 0 ]; then
    status=1
fi
printf '\nPlayback, multi-output routing, selected Audio Source, and loaded presets require manual verification.\n'
exit "$status"
