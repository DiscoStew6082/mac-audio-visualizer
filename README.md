# mac-audio-visualizer

Winamp/MilkDrop-style real-time audio visualizer for macOS, using **BlackHole** + **ProjectMilkSyphon**.

Routes any system audio (Twitch streams, browser radio, etc.) into a MilkDrop/projectM visualizer while preserving normal headphone/speaker output.

## Architecture

```
Audio Source (Chrome/Twitch/Safari)
    → macOS Output
        ├──→ Headphones / Speakers  (normal listening)
        └──→ BlackHole 2ch          (virtual loopback)
                └──→ ProjectMilkSyphon (visualizer reacts in real-time)
```

## Features

- Real-time MilkDrop/projectM visualizer from any system audio source
- No screen capture needed — pure audio routing via BlackHole virtual driver
- 9,795 MilkDrop presets + 66 textures included
- Multi-output routing so you hear audio normally while visualizing
- CLI checks for exact input-device availability, the visualizer process, and preset files

## Setup

See [SKILL.md](SKILL.md) for step-by-step instructions covering:

1. Install BlackHole 2ch via Homebrew
2. Install ProjectMilkSyphon v3.8
3. Download MilkDrop presets + textures
4. Configure multi-output audio routing in Audio MIDI Setup
5. Point ProjectMilkSyphon at BlackHole 2ch

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/install-presets.sh` | One-shot download of all ~10K presets and texture packs |
| `scripts/verify-audio-route.sh [audio_device]` | Check exact input availability, visualizer process, and preset files |
| `scripts/launch_twitch_visualizer.sh <channel> [audio_device]` | Open the channel URL and request the visualizer launch |

The scripts resolve `SwitchAudioSource` once from PATH or Apple Silicon/Intel Homebrew. They report missing prerequisites or command failures with a nonzero exit status. `PROJECT_MILK_APP` may point to an alternate app location.

Opening a URL does not establish playback. Available devices and preset files do not establish the selected audio route or loaded presets. Select the multi-output route and visualizer Audio Source, then check audible playback and visual response manually.

## Offline script checks

Run `python3 -m unittest discover -s tests -v`. Tests use fake commands and temporary files; they do not open apps or change audio settings. Native macOS routing still needs manual verification.

## Requirements

- macOS 13+ (for ProjectMilkSyphon v3.8)
- [Homebrew](https://brew.sh)
- [BlackHole 2ch](https://github.com/_existentialAudio/BlackHole) (`brew install blackhole-2ch`)
- [ProjectMilkSyphon v3.8+](https://vdmx.vidvox.net/blog/projectmilksyphon)
- [SwitchAudioSource](https://github.com/deweller/switchaudio-osx) (`brew install switchaudio-osx`)

## License

MIT — do whatever you want with it.
