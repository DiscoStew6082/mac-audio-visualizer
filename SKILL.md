---
name: mac-audio-visualizer
description: Set up a Winamp/MilkDrop-style audio visualizer on macOS using BlackHole + ProjectMilkSyphon. Routes browser/Twitch/stream audio to a real-time MilkDrop visualizer while preserving normal headphone output. Use when user wants music visualization, MilkDrop visuals, or audio-reactive graphics from stream audio.
---

# Mac Audio Visualizer Setup

## Goal

Route live audio (Twitch streams, browser radio, internet radio) into a MilkDrop/projectM-style visualizer **without stopping normal headphone/speaker output**.

```
Audio Source (Chrome/Twitch/Safari)
    → macOS Output
        ├──→ External Headphones / Speakers (normal listening)
        └──→ BlackHole 2ch (virtual loopback)
                └──→ ProjectMilkSyphon (visualizer reacts in real-time)
```

## Prerequisites

- macOS 13+ (for ProjectMilkSyphon v3.8)
- Homebrew installed
- Mac Studio or any Mac with audio output

---

## Step 1: Install BlackHole Virtual Audio Driver

BlackHole creates a virtual audio device that lets you capture system audio without screen recording.

**Full details:** [docs/blackhole.md](docs/blackhole.md)

```bash
brew install blackhole-2ch
```

After installation, **reboot your Mac** — the kernel extension requires it.

---

## Step 2: Install ProjectMilkSyphon Visualizer

ProjectMilkSyphon v3.8+ can capture system audio directly on macOS 13+.

1. Visit: **https://vdmx.vidvox.net/blog/projectmilksyphon**
2. Download and install the `.dmg`

### Install Presets

```bash
./scripts/install-presets.sh
```

This downloads ~9,795 MilkDrop presets + 66 textures to `~/share/projectM/`.

In ProjectMilkSyphon: Settings → Files tab → navigate to `~/share/projectM/`

---

## Step 3: Create Multi-Output Audio Route

**Full details:** [docs/blackhole.md](docs/blackhole.md)

Use **Audio MIDI Setup** (`Cmd+Space` → "MIDI"):

1. Click the `+` button bottom-left
2. Select **Create Multi-Output Device**
3. Check both your headphones AND **BlackHole 2ch**
4. Right-click → **Use This Device For Sound Output**

---

## Step 4: Configure ProjectMilkSyphon

1. Launch **ProjectMilkSyphon** from `/Applications/`
2. Click the **Settings gear icon**
3. Go to **Audio Source** → select **BlackHole 2ch**

The visualizer begins reacting immediately.

---

## Step 5: Verify Everything Works

```bash
./scripts/verify-audio-route.sh
```

Then open a stream in your browser — you should hear audio and see the visualizer moving.

### Quick Launch for Twitch

```bash
./scripts/launch_twitch_visualizer.sh <channel>
# Example:
./scripts/launch_twitch_visualizer.sh your_channel_name
```

---

## Alternative: Loopback (Paid)

If you prefer not to use BlackHole, [Rogue Amoeba Loopback](https://rogueamoeba.com/loopback/) ($129) offers a GUI-based routing with per-app capture.

**Full comparison:** [docs/loopback.md](docs/loopback.md)

---

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for the full matrix of issues and fixes, or run:

```bash
./scripts/verify-audio-route.sh
```

---

## Architecture Notes

| Component | Role |
|-----------|------|
| BlackHole 2ch | Virtual audio cable — copies output to an input device |
| Multi-Output Device | Merges headphone + BlackHole into single logical output |
| ProjectMilkSyphon | Receives BlackHole input, runs MilkDrop visualizer, outputs Syphon |
| SwitchAudioSource | CLI tool for managing audio routing without GUI |

### Why this works

macOS normally has one active output. By creating a Multi-Output Device that contains both your headphones AND BlackHole:
- Audio plays to headphones (you hear it)
- Audio ALSO plays to BlackHole
- ProjectMilkSyphon reads from BlackHole as an input device
- Visualizer renders in real-time

No screen capture needed — this is pure audio routing.
