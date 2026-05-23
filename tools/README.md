# Squat Sensei TTS Generator

Gemini TTS (Fenrir voice) でコーチング音声を事前生成するスクリプトです。

## 前提

- Python 3.10+
- [Google AI Studio](https://aistudio.google.com/) で取得した API キー

## セットアップ

```bash
cd "Squat Sensei"
python3 -m venv tools/.venv
source tools/.venv/bin/activate
pip install google-genai
cp tools/.env.example tools/.env
# tools/.env を開いて GEMINI_API_KEY を設定
```

## 生成

```bash
source tools/.venv/bin/activate
python3 tools/generate_tts.py
```

または:

```bash
export GEMINI_API_KEY=your_key_here
python3 tools/generate_tts.py
```

出力先: `Squat Sensei/Resources/Audio/rep_03.wav` 〜 `rep_20.wav`

## 設定

| 項目 | 値 | 変更場所 |
|------|-----|---------|
| モデル | `gemini-2.5-flash-preview-tts` | `tools/generate_tts.py` の `MODEL` |
| 声 | `Fenrir` | `tools/generate_tts.py` の `VOICE` |
| セリフ | rep 3〜20 | `tools/generate_tts.py` の `LINES` |

## 音声の差し替え

1. `LINES` の prompt を編集（`[shouting]` などの audio tag も調整可）
2. スクリプトを再実行
3. Xcode でビルド＆実機確認

## 注意

- API キーはリポジトリにコミットしないこと
- 生成した WAV はアプリバンドルに同梱され、実行時はオフラインで再生されます
