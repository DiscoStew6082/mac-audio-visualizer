# Troubleshooting

## "I hear audio but visualizer does not move"

1. ProjectMilkSyphon Settings → Audio Source → confirm **BlackHole 2ch** is selected (not Built-in Microphone)
2. System Settings → Privacy & Security → **Microphone** → ensure ProjectMilkSyphon has permission
3. System Settings → Privacy & Security → **System Audio Capture** → ensure ProjectMilkSyphon has permission
4. Increase volume on your audio source — very quiet audio won't trigger the visualizer

## "Visualizer moves but I hear nothing"

1. Audio MIDI Setup → right-click multi-output device → confirm headphones are checked
2. System Settings → Sound → Output → select your headphones (not BlackHole alone)
3. `SwitchAudioSource -a -t output` — should show both BlackHole AND headphones

## "BlackHole 2ch does not show up in audio devices"

1. **Reboot** — kernel extensions load at startup
2. If already rebooted, run: `sudo killall coreaudiod && sleep 4`
3. Check driver is installed: `ls /Library/Audio/Plug-Ins/HAL/BlackHole2ch.driver`

## "Audio level is too low or clipping in visualizer"

1. ProjectMilkSyphon Settings → adjust **Gain** slider upward
2. In Audio MIDI Setup multi-output device, you can lower BlackHole relative to headphones to balance

## "Bluetooth headphones not included in the route"

1. Bluetooth devices appear as separate output devices
2. Add your Bluetooth device to the multi-output device alongside BlackHole
3. Note: Bluetooth introduces latency — visualizer may be slightly behind audio

## "ProjectMilkSyphon shows no presets / blank preset list"

1. Settings → Files tab → navigate to `/Users/YOUR_USER/share/projectM/`
2. Confirm it contains folders like `Reaction/`, `Fractal/`, `Geometric/` with `.milk` files inside
3. If empty, re-download the preset pack:
   ```bash
   ./scripts/install-presets.sh
   ```

## "App won't launch / security warning"

1. System Settings → Privacy & Security → scroll down → "Open anyway" for ProjectMilkSyphon
2. Or: Control-click ProjectMilkSyphon.app → Open → confirm

---

## Diagnostic Script

Run the verification script to check all components at once:

```bash
./scripts/verify-audio-route.sh
```

Checks:
- All audio input/output devices
- BlackHole registration with coreaudiod
- Whether ProjectMilkSyphon is running
- Preset count in `~/share/projectM/`