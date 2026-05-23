//
//  SpeechCoach.swift
//  Squat Sensei
//

import AVFoundation

@MainActor
final class SpeechCoach: NSObject {
    private var player: AVAudioPlayer?
    private var synthesizer: AVSpeechSynthesizer?
    private var queue: [QueuedCue] = []
    private var isPlaying = false

    private struct QueuedCue {
        let audioFileName: String?
        let fallbackText: String?
    }

    override init() {
        super.init()
        configureAudioSession()
    }

    func play(_ audioFileName: String?, fallbackText: String? = nil) {
        guard audioFileName != nil || !(fallbackText?.isEmpty ?? true) else { return }
        queue.append(QueuedCue(audioFileName: audioFileName, fallbackText: fallbackText))
        playNextIfNeeded()
    }

    func stop() {
        queue.removeAll()
        player?.stop()
        player = nil
        synthesizer?.stopSpeaking(at: .immediate)
        synthesizer = nil
        isPlaying = false
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            // Playback will still attempt; session setup is best-effort.
        }
    }

    private func playNextIfNeeded() {
        guard !isPlaying, !queue.isEmpty else { return }

        let cue = queue.removeFirst()

        if let audioFileName = cue.audioFileName,
           let url = Bundle.main.url(forResource: audioFileName, withExtension: "wav", subdirectory: "Audio")
            ?? Bundle.main.url(forResource: audioFileName, withExtension: "wav"),
           playAudioFile(at: url) {
            return
        }

        if let fallbackText = cue.fallbackText, !fallbackText.isEmpty {
            playSpeech(fallbackText)
        } else {
            playNextIfNeeded()
        }
    }

    @discardableResult
    private func playAudioFile(at url: URL) -> Bool {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            player = audioPlayer
            isPlaying = true
            return true
        } catch {
            return false
        }
    }

    private func playSpeech(_ text: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.delegate = self
        synthesizer = speechSynthesizer

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        isPlaying = true
        speechSynthesizer.speak(utterance)
    }
}

extension SpeechCoach: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            isPlaying = false
            playNextIfNeeded()
        }
    }

    nonisolated func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: (any Error)?) {
        Task { @MainActor in
            isPlaying = false
            playNextIfNeeded()
        }
    }
}

extension SpeechCoach: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            isPlaying = false
            playNextIfNeeded()
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            isPlaying = false
            playNextIfNeeded()
        }
    }
}
