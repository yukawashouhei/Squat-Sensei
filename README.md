# Squat Sensei

An AI squat counter for iOS — on-device pose detection, real-time coaching, and expressive voice lines powered by **Gemini 3.1 Flash TTS**. Built with **Google Antigravity**.

## About

Squat Sensei uses your iPhone camera and Apple Vision to count squats automatically. From rep 3 onward, an energetic AI coach delivers motivational voice lines generated with Gemini 3.1 Flash TTS. Complete 20 reps to finish today's session and keep your streak alive.

This project was developed for the Google I/O Hackathon using **Google Antigravity** as the primary development agent, from SwiftUI UI and camera pipeline to Gemini TTS audio integration.

## Features

- **Automatic rep counting** — Apple Vision body pose detection; no wearables or manual tapping
- **Real-time skeleton overlay** — green pose overlay so you know tracking is working
- **Gemini 3.1 Flash TTS coach voice** — pre-generated Fenrir voice lines with audio tags like `[shouting]` and `[energetic]`; bundled for offline playback
- **Daily streak tracker** — complete 20 reps to mark the day; weekly progress on the home screen
- **Face Cover** — choose from 24 emoji masks to cover your face during sessions for privacy

## Tech Stack

| Layer | Technology |
|-------|------------|
| App | SwiftUI, Swift 6, Observation |
| Pose | On-device `VNDetectHumanBodyPoseRequest`, `VNDetectFaceRectanglesRequest` |
| Voice | Gemini 3.1 Flash TTS (Fenrir voice) |
| Development | Google Antigravity |
| Audio playback | AVAudioPlayer (bundled WAV) |

## Requirements

- Xcode 26.2+
- iOS 26.2+
- iPhone with front camera

## Getting Started

1. Clone this repository
2. Open `Squat Sensei.xcodeproj` in Xcode
3. Select a device or simulator
4. Run (⌘R)

Coach audio (`rep_03.wav`–`rep_20.wav`) is already bundled. No API key is required to run the app.

## Regenerating Coach Audio (optional)

To regenerate voice lines with Gemini TTS:

```bash
cd "Squat Sensei"
python3 -m venv tools/.venv
source tools/.venv/bin/activate
pip install google-genai
cp tools/.env.example tools/.env
# Set GEMINI_API_KEY in tools/.env
python3 tools/generate_tts.py
```

See [tools/README.md](tools/README.md) for details. **Never commit `tools/.env` or API keys.**

## Privacy

- Camera is used only for on-device pose and face detection during squat sessions
- No video recording, no cloud upload of camera frames
- All pose analysis runs locally on your device

## Repository

https://github.com/yukawashouhei/Squat-Sensei
