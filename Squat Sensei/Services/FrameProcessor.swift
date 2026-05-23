//
//  FrameProcessor.swift
//  Squat Sensei
//

import CoreMedia

struct FrameAnalysisResult: Sendable {
    let joints: [JointPoint]
    let completedRep: Int?
}

final class FrameProcessor: @unchecked Sendable {
    private let poseDetector = PoseDetector()
    private var squatCounter = SquatCounter()
    private var isProcessingFrame = false

    func reset() {
        squatCounter.reset()
        isProcessingFrame = false
    }

    func process(_ sampleBuffer: CMSampleBuffer) -> FrameAnalysisResult {
        guard !isProcessingFrame else {
            return FrameAnalysisResult(joints: [], completedRep: nil)
        }

        isProcessingFrame = true
        defer { isProcessingFrame = false }

        let joints = poseDetector.detect(in: sampleBuffer)
        let completedRep = squatCounter.process(joints: joints)
        return FrameAnalysisResult(joints: joints, completedRep: completedRep)
    }
}
