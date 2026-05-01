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

BlackHole creates a virtual audio device that lets you capture system audio.

```bash
brew install blackhole-2ch
```

After installation, **reboot your Mac** — the kernel extension requires it.

### Register with macOS Audio Server

If you've upgraded from an older BlackHole or the driver isn't detected:

```bash
sudo killall coreaudiod && sleep 4 && SwitchAudioSource -a
```

You should see `BlackHole 2ch` listed under both inputs and outputs:
- **Inputs:** BlackHole 2ch, External Microphone
- **Outputs:** BlackHole 2ch, External Headphones, Mac Studio Speakers

If `SwitchAudioSource` is not installed:
```bash
brew install switchaudio-osx
```

---

## Step 2: Install ProjectMilkSyphon Visualizer

ProjectMilkSyphon v3.8+ can capture system audio directly on macOS 13+.

### Download

1. Visit: **https://vdmx.vidvox.net/blog/projectmilksyphon**
2. Click "Download ProjectMilkSyphon (v3.8 – August 13, 2025)"
3. Mount the `.dmg` and run the installer

If you already have a `.pkg` file from a mounted volume:
```bash
# Extract app from flat package
cd /tmp && mkdir PMS_extract
xar -xf "/Volumes/YourVolume/ProjectMilkSyphon.pkg" component.pkg
cat component.pkg/Payload | gunzip -d | cpio -idv
cp -R extracted/path/ProjectMilkSyphon.app /Applications/
```

### Install Presets

ProjectMilkSyphon ships without presets. Download the "Cream of the Crop" pack (~10K MilkDrop presets):

```bash
# Download preset pack and textures
curl -L -o /tmp/presets.tar.gz \
  "https://github.com/projectM-visualizer/presets-cream-of-the-crop/archive/master.tar.gz"

tar -xzf /tmp/presets.tar.gz -C ~/
mv ~/presets-cream-of-the-crop-master ~/share/projectM

# Download required textures
curl -L -o /tmp/textures.tar.gz \
  "https://github.com/projectM-visualizer/presets-milkdrop-texture-pack/archive/master.tar.gz"

tar -xzf /tmp/textures.tar.gz -C ~/
cp -R ~/presets-milkdrop-texture-pack-master/textures ~/share/projectM/

# Symlink to standard location
mkdir -p ~/.local/share
ln -sf ~/share/projectM ~/.local/share/projectM
```

**9,795 presets + 66 textures** will be available at `~/share/projectM/`.

In ProjectMilkSyphon: Settings → Files tab → navigate to `/Users/YOUR_USERNAME/share/projectM/`

---

## Step 3: Create Multi-Output Audio Route

Use **Audio MIDI Setup** (open via Spotlight: `Cmd+Space` → "MIDI"):

1. Click the `+` button bottom left
2. Select **Create Multi-Output Device**
3. In the right panel, check BOTH:
   - Your headphones or audio interface (e.g., "External Headphones")
   - **BlackHole 2ch**
4. Right-click the new multi-output device → **Use This Device For Sound Output**

All system audio now goes to both your headphones AND BlackHole simultaneously.

**Verify from CLI:**
```bash
SwitchAudioSource -a -t output
# Should show: BlackHole 2ch, External Headphones (both checked in multi-output)
```

---

## Step 4: Configure ProjectMilkSyphon

1. Launch **ProjectMilkSyphon** from `/Applications/`
2. Click the **Settings gear icon**
3. Go to **Audio Source**
4. Select **BlackHole 2ch**

The visualizer should immediately begin reacting to any audio playing on your Mac (Twitch, browser radio, etc.).

---

## Step 5: Verify Everything Works

1. Open Chrome/Firefox → play a Twitch stream or online radio
2. Confirm you hear audio through your headphones normally
3. Check that ProjectMilkSyphon's visualizer window shows moving graphics synced to the music

### CLI Verification Commands

```bash
# List all audio devices (inputs)
SwitchAudioSource -a -t input
# Expected: BlackHole 2ch, External Microphone

# List all audio devices (outputs)
SwitchAudioSource -a -t output
# Expected: BlackHole 2ch, External Headphones (+ others)

# Check if ProjectMilkSyphon is running
pgrep -l ProjectMilkSyphon
```

---

## Troubleshooting Checklist

### "I hear audio but visualizer does not move"

1. ProjectMilkSyphon Settings → Audio Source → confirm **BlackHole 2ch** is selected (not Built-in Microphone)
2. System Settings → Privacy & Security → **Microphone** → ensure ProjectMilkSyphon has permission
3. System Settings → Privacy & Security → **System Audio Capture** → ensure ProjectMilkSyphon has permission
4. Increase volume on your audio source — very quiet audio won't trigger the visualizer

### "Visualizer moves but I hear nothing"

1. Audio MIDI Setup → right-click multi-output device → confirm headphones are checked
2. System Settings → Sound → Output → select your headphones (not BlackHole alone)
3. `SwitchAudioSource -a -t output` — should show both BlackHole AND headphones

### "BlackHole 2ch does not show up in audio devices"

1. **Reboot** — kernel extensions load at startup
2. If already rebooted, run: `sudo killall coreaudiod && sleep 4`
3. Check driver is installed: `ls /Library/Audio/Plug-Ins/HAL/BlackHole2ch.driver`

### "Audio level is too low or clipping in visualizer"

1. ProjectMilkSyphon Settings → adjust **Gain** slider upward
2. In Audio MIDI Setup multi-output device, you can lower BlackHole relative to headphones to balance

### "Bluetooth headphones not included in the route"

1. Bluetooth devices appear as separate output devices
2. Add your Bluetooth device to the multi-output device alongside BlackHole
3. Note: Bluetooth introduces latency — visualizer may be slightly behind audio

### "ProjectMilkSyphon shows no presets / blank preset list"

1. Settings → Files tab → navigate to `/Users/YOUR_USER/share/projectM/`
2. Confirm it contains folders like `Reaction/`, `Fractal/`, `Geometric/` with `.milk` files inside
3. If empty, re-download the preset pack (see Step 2)

### "App won't launch / security warning"

1. System Settings → Privacy & Security → scroll down → "Open anyway" for ProjectMilkSyphon
2. Or: Control-click ProjectMilkSyphon.app → Open → confirm

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