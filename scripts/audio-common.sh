#!/bin/bash
# Shared read-only dependency and exact-device checks. Sourced by the scripts.
resolve_switch_audio_source() {
    SWITCH_AUDIO_SOURCE=$(command -v SwitchAudioSource || true)
    if [ -n "$SWITCH_AUDIO_SOURCE" ]; then
        return 0
    fi
    # Both Apple Silicon and Intel Homebrew installations are supported.
    local candidate
    for candidate in "${1:-/opt/homebrew/bin/SwitchAudioSource}" "${2:-/usr/local/bin/SwitchAudioSource}"; do
        if [ -x "$candidate" ]; then
            SWITCH_AUDIO_SOURCE="$candidate"
            return 0
        fi
    done
    echo "SwitchAudioSource is unavailable. Install switchaudio-osx before continuing." >&2
    return 1
}

has_audio_device() {
    # Device names are complete lines, not regular expressions or substrings.
    case "$2" in
        ''|*$'\n'*|*$'\r'*) return 1 ;;
    esac
    printf '%s\n' "$1" | grep -Fxq -- "$2"
}

count_presets() {
    if [ -d "$1" ]; then
        find "$1" -type f -name '*.milk' | wc -l | tr -d '[:space:]'
    else
        printf '0\n'
    fi
}
