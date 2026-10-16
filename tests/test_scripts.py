"""Dependency-free script checks. Fake commands never change the host audio route."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class AudioScripts(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.env = {**os.environ, "PATH": f"{self.bin}:/usr/bin:/bin", "HOME": str(self.root),
                    "PROJECT_MILK_APP": str(self.root / "ProjectMilkSyphon.app"),
                    "MOCK_INPUTS": "BlackHole 2ch\nMicrophone", "MOCK_RUNNING": "1",
                    "MOCK_LOG": str(self.root / "open.log"), "MOCK_FAIL": "0"}
        Path(self.env["PROJECT_MILK_APP"]).mkdir()
        presets = self.root / "share/projectM"
        presets.mkdir(parents=True)
        (presets / "sample.milk").touch()
        self.command("SwitchAudioSource", 'if [ "$MOCK_FAIL" = 1 ]; then exit 23; fi\nif [ "$3" = input ]; then printf "%s\\n" "$MOCK_INPUTS"; else echo Speakers; fi')
        self.command("open", 'printf "%s\\n" "$*" >> "$MOCK_LOG"\nexit "${MOCK_OPEN_FAIL:-0}"')
        self.command("pgrep", '[ "$MOCK_RUNNING" = 1 ]')

    def command(self, name, body):
        path = self.bin / name
        path.write_text("#!/bin/bash\n" + body + "\n")
        path.chmod(0o755)
        return path

    def run_script(self, script, *args):
        return subprocess.run(["/bin/bash", str(ROOT / "scripts" / script), *args],
                              env=self.env, capture_output=True, text=True, input="n\n")

    def test_launcher_reports_only_observed_state(self):
        result = self.run_script("launch_twitch_visualizer.sh", "sample_channel")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("Playback and visualizer routing have not been verified", result.stdout)
        self.assertNotIn("playing in browser", result.stdout)
        self.assertNotIn("Presets loaded", result.stdout)
        self.assertEqual(Path(self.env["MOCK_LOG"]).read_text(), "https://twitch.tv/sample_channel\n")

    def test_missing_exact_input_fails_without_launch(self):
        for name in ["BlackHole 16ch", "Not BlackHole 2ch", "BlackHole 2ch Extra"]:
            self.env["MOCK_INPUTS"] = name
            result = self.run_script("launch_twitch_visualizer.sh", "sample_channel")
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(Path(self.env["MOCK_LOG"]).exists())

    def test_regex_metacharacters_are_literal(self):
        self.env["MOCK_INPUTS"] = "BlackHole 2ch"
        result = self.run_script("verify-audio-route.sh", "BlackHole .*ch")
        self.assertNotEqual(result.returncode, 0)

    def test_dependency_and_open_failures_propagate(self):
        self.env["MOCK_FAIL"] = "1"
        self.assertNotEqual(self.run_script("verify-audio-route.sh").returncode, 0)
        self.assertNotEqual(self.run_script("launch_twitch_visualizer.sh", "sample").returncode, 0)
        self.env["MOCK_FAIL"] = "0"
        self.env["MOCK_OPEN_FAIL"] = "17"
        self.assertEqual(self.run_script("launch_twitch_visualizer.sh", "sample").returncode, 17)

    def test_launch_request_is_not_claimed_running(self):
        self.env["MOCK_RUNNING"] = "0"
        result = self.run_script("launch_twitch_visualizer.sh", "sample")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("launch requested", result.stdout)
        self.assertNotIn("process is running", result.stdout)
        self.assertNotEqual(self.run_script("verify-audio-route.sh").returncode, 0)

    def test_fallback_resolver_is_reused(self):
        fallback = self.root / "fallback"
        (self.bin / "SwitchAudioSource").rename(fallback)
        result = subprocess.run(["/bin/bash", "-c",
            'source "$1"; resolve_switch_audio_source "$2" /missing; "$SWITCH_AUDIO_SOURCE" -a -t input',
            "test", str(ROOT / "scripts/audio-common.sh"), str(fallback)],
            env=self.env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.strip(), self.env["MOCK_INPUTS"])

    def test_diagnostic_success_does_not_claim_route_verification(self):
        result = self.run_script("verify-audio-route.sh")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("require manual verification", result.stdout)

    def test_empty_presets_and_invalid_channel_fail(self):
        (self.root / "share/projectM/sample.milk").unlink()
        self.assertNotEqual(self.run_script("verify-audio-route.sh").returncode, 0)
        self.assertNotEqual(self.run_script("launch_twitch_visualizer.sh", "sample").returncode, 0)
        self.assertNotEqual(self.run_script("launch_twitch_visualizer.sh", "sample?extra=1").returncode, 0)
        self.assertFalse(Path(self.env["MOCK_LOG"]).exists())


if __name__ == "__main__":
    unittest.main()
