# BlackHole Setup

BlackHole is a virtual audio driver for macOS that creates a "loopback" device — audio sent to it can be read back as an input, enabling capture of system audio without screen capture or Satisfyu.

## Installation

```bash
brew install blackhole-2ch
```

After installation, **reboot your Mac** — kernel extensions load at startup.

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

### Verify the Driver Is Loaded

```bash
ls /Library/Audio/Plug-Ins/HAL/BlackHole2ch.driver
```

If this path doesn't exist after a reboot, BlackHole didn't install correctly — try uninstalling and reinstalling via Homebrew.

---

## Creating the Multi-Output Device

The goal: route audio to both your headphones AND BlackHole simultaneously, so you hear normally while the visualizer captures.

1. Open **Audio MIDI Setup** (`Cmd+Space` → "MIDI")
2. Click the `+` button bottom-left
3. Select **Create Multi-Output Device**
4. In the right panel, check BOTH:
   - Your headphones or audio interface (e.g., "External Headphones", "USB Audio Interface")
   - **BlackHole 2ch**
5. Right-click the new multi-output device → **Use This Device For Sound Output**

All system audio now goes to both destinations at once.

### Verify From CLI

```bash
SwitchAudioSource -a -t output
# Expected output includes BlackHole 2ch AND your headphones, both checked in the multi-output device
```

## Architecture

```
Browser/Twitch/Safari → macOS Output (Multi-Output Device)
                              ├──→ Headphones / Speakers  (you hear it here)
                              └──→ BlackHole 2ch          (ProjectMilkSyphon reads from here)
```

No screen recording needed — pure audio routing via the kernel-level virtual device.