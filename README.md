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
- CLI diagnostic tool to verify the entire audio chain

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
| `scripts/verify-audio-route.sh` | CLI diagnostic — check BlackHole, ProjectMilkSyphon, preset count |

## Requirements

- macOS 13+ (for ProjectMilkSyphon v3.8)
- [Homebrew](https://brew.sh)
- [BlackHole 2ch](https://github.com/_existentialAudio/BlackHole) (`brew install blackhole-2ch`)
- [ProjectMilkSyphon v3.8+](https://vdmx.vidvox.net/blog/projectmilksyphon)
- [SwitchAudioSource](https://github.com/deweller/switchaudio-osx) (`brew install switchaudio-osx`)

## License

MIT — do whatever you want with it.