#!/usr/bin/env python3
"""
Generate Squat Sensei coach audio files using Gemini TTS (Fenrir voice).

Usage:
    export GEMINI_API_KEY=your_key_here
    python3 tools/generate_tts.py
"""

from __future__ import annotations

import os
import sys
import time
import wave
from pathlib import Path

try:
    from google import genai
    from google.genai import types
except ImportError:
    print("Missing dependency. Install with: pip install google-genai")
    sys.exit(1)

MODEL = "gemini-2.5-flash-preview-tts"
VOICE = "Fenrir"
OUTPUT_DIR = Path(__file__).resolve().parent.parent / "Squat Sensei" / "Resources" / "Audio"

# (rep_number, prompt with audio/style tags)
LINES: list[tuple[int, str]] = [
    (
        3,
        "[shouting][energetic] You're not pushing yourself up, you're pushing the Earth down!",
    ),
    (4, "[shouting][intense] Defy gravity! Make Isaac Newton cry!"),
    (5, "[shouting][encouraging] You can do it!"),
    (
        6,
        "[shouting][motivating] Stop staring at the dust on the floor, look at your future!",
    ),
    (
        7,
        "[shouting][energetic] Your muscles aren't crying, they're cheering for you!",
    ),
    (8, "[fast][excited] Eight! Next is nine!"),
    (9, "[shouting][intense] Night! Come on! Last one!"),
    (10, "[shouting][intense] Nine point one! Your thighs are shaking!"),
    (11, "[shouting][demanding] Nine point two! Don't quit on me!"),
    (12, "[shouting][energetic] Nine point three! Gravity is just a number!"),
    (13, "[shouting][commanding] Nine point four! Breathe in, push up!"),
    (14, "[shouting][encouraging] Nine point five! We are halfway to ten!"),
    (15, "[shouting][intense] Nine point six! The floor is lava!"),
    (16, "[shouting][playful] Nine point seven! Lift like your ex is watching!"),
    (17, "[shouting][fast] Nine point eight! Are you counting? I'm not!"),
    (18, "[shouting][intense] Nine point nine! One more to ten!"),
    (19, "[shouting][building] Nine point nine nine!"),
    (
        20,
        "[shouting][celebratory] TEN! [short pause] You just did twenty reps! "
        "Your quads are now officially thicker than the Golden Gate Bridge cables!",
    ),
]


def write_wave_file(filename: Path, pcm: bytes, channels: int = 1, rate: int = 24000, sample_width: int = 2) -> None:
    with wave.open(str(filename), "wb") as wf:
        wf.setnchannels(channels)
        wf.setsampwidth(sample_width)
        wf.setframerate(rate)
        wf.writeframes(pcm)


def generate_line(client: genai.Client, rep: int, prompt: str) -> bytes:
    response = client.models.generate_content(
        model=MODEL,
        contents=prompt,
        config=types.GenerateContentConfig(
            response_modalities=["AUDIO"],
            speech_config=types.SpeechConfig(
                voice_config=types.VoiceConfig(
                    prebuilt_voice_config=types.PrebuiltVoiceConfig(
                        voice_name=VOICE,
                    )
                )
            ),
        ),
    )

    if not response.candidates:
        raise RuntimeError(
            f"No candidates returned for rep {rep} (prompt_feedback={response.prompt_feedback})"
        )

    candidate = response.candidates[0]
    if not candidate.content or not candidate.content.parts:
        raise RuntimeError(
            f"No content parts for rep {rep} (finish_reason={candidate.finish_reason})"
        )

    for part in candidate.content.parts:
        if part.inline_data and part.inline_data.data:
            return part.inline_data.data

    raise RuntimeError(f"No audio data returned for rep {rep}")


def load_env_file() -> None:
    env_path = Path(__file__).resolve().parent / ".env"
    if not env_path.exists():
        return
    for line in env_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip().strip('"').strip("'"))


def main() -> None:
    load_env_file()
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("Error: Set GEMINI_API_KEY environment variable.")
        print("  export GEMINI_API_KEY=your_key_here")
        print("  or create tools/.env with GEMINI_API_KEY=...")
        sys.exit(1)

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    client = genai.Client(api_key=api_key)

    print(f"Model: {MODEL}")
    print(f"Voice: {VOICE}")
    print(f"Output: {OUTPUT_DIR}")
    print(f"Generating {len(LINES)} audio files...\n")

    for rep, prompt in LINES:
        filename = OUTPUT_DIR / f"rep_{rep:02d}.wav"
        if filename.exists() and filename.stat().st_size > 0:
            print(f"  rep {rep:02d} -> {filename.name} ... SKIP (exists)")
            continue

        print(f"  rep {rep:02d} -> {filename.name} ...", end=" ", flush=True)

        last_error: Exception | None = None
        for attempt in range(1, 4):
            try:
                pcm = generate_line(client, rep, prompt)
                write_wave_file(filename, pcm)
                print("OK" if attempt == 1 else f"OK (attempt {attempt})")
                last_error = None
                break
            except Exception as exc:
                last_error = exc
                if attempt < 3:
                    wait = 5 * attempt
                    print(f"retry in {wait}s ({exc})", end=" ... ", flush=True)
                    time.sleep(wait)
                else:
                    print(f"FAILED ({exc})")

        if last_error is not None:
            sys.exit(1)

        time.sleep(0.8)

    print(f"\nDone. Generated {len(LINES)} files in {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
