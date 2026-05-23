//
//  SpeechCoach.swift
//  Squat Sensei
//

import AVFoundation

@MainActor
final class SpeechCoach: NSObject {
    private let synthesizer = AVSpeechSynthesizer()
    private var queue: [String] = []
    private var isSpeaking = false

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String?) {
        guard let text, !text.isEmpty else { return }
        queue.append(text)
        speakNextIfNeeded()
    }

    func stop() {
        queue.removeAll()
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    private func speakNextIfNeeded() {
        guard !isSpeaking, !queue.isEmpty else { return }
        let next = queue.removeFirst()
        let utterance = AVSpeechUtterance(string: next)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 1.0
        isSpeaking = true
        synthesizer.speak(utterance)
    }
}

extension SpeechCoach: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            isSpeaking = false
            speakNextIfNeeded()
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            isSpeaking = false
            speakNextIfNeeded()
        }
    }
}
