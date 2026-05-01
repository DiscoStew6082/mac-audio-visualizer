# Loopback Alternative (Paid)

If you prefer not to use BlackHole, **Loopback** from Rogue Amoeba is a paid ($129) alternative with a more polished UI and easier multi-route management. It also supports per-app routing if you only want to capture specific applications.

## Route: Browser → Loopback → Headphones + Visualizer

```
Browser (Twitch/Safari)
    ↓
Loopback Virtual Device
    ├──→ Physical Output (headphones/speakers) ← you hear it here
    └──→ Monitor input for ProjectMilkSyphon
```

Unlike BlackHole's multi-output approach, Loopback creates a single virtual device that you set as your system output. You then route from that virtual device to both your headphones and a monitor input simultaneously — all within Loopback's UI.

## Setup

1. Download **Loopback** from https://rogueamoeba.com/loopback/
2. Install and grant microphone/audio permissions when prompted
3. In Loopback, create a new virtual device
4. Add your browser as a source app (or "System Audio" for all apps)
5. Enable **Output to** your physical headphones/speakers
6. Enable **Monitor** — this makes the audio available as an input for ProjectMilkSyphon
7. Set your system output to the Loopback virtual device

## Point ProjectMilkSyphon at the Monitor Input

In ProjectMilkSyphon Settings → Audio Source:
- If you see a Loopback monitor device listed (e.g., "Loopback Monitor"), select it
- You hear audio normally through headphones and the visualizer reacts

## Why BlackHole Is Used in the Main Guide

| | BlackHole | Loopback |
|-|-----------|----------|
| Price | Free (open source) | $129 |
| Multi-output per-app routing | No — uses macOS multi-output aggregate device | Yes — built into UI |
| Stability | Kernel extension, occasional upgrades break it | Userspace driver, more stable |
| Per-app capture | Requires aggregate + BlackHole chaining | Native checkbox per app |

Either works. The main guide uses BlackHole because it's free and widely documented.