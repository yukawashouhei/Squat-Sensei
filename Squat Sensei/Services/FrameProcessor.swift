//
//  FrameProcessor.swift
//  Squat Sensei
//

import CoreGraphics
import CoreMedia
import Vision

struct FrameAnalysisResult: Sendable {
    let joints: [JointPoint]
    let completedRep: Int?
    let face: FaceRegion?
}

final class FrameProcessor: @unchecked Sendable {
    private let poseDetector = PoseDetector()
    private let faceDetector = FaceDetector()
    private var squatCounter = SquatCounter()
    private var isProcessingFrame = false
    private var lastFace: FaceRegion?

    func reset() {
        squatCounter.reset()
        isProcessingFrame = false
        lastFace = nil
    }

    func process(_ sampleBuffer: CMSampleBuffer) -> FrameAnalysisResult {
        guard !isProcessingFrame else {
            return FrameAnalysisResult(joints: [], completedRep: nil, face: lastFace)
        }

        isProcessingFrame = true
        defer { isProcessingFrame = false }

        let joints = poseDetector.detect(in: sampleBuffer)
        let completedRep = squatCounter.process(joints: joints)

        let detectedFace = faceDetector.detect(in: sampleBuffer)
        let face = detectedFace ?? inferFace(from: joints)
        if let face {
            lastFace = face
        }

        return FrameAnalysisResult(joints: joints, completedRep: completedRep, face: face)
    }

    private func inferFace(from joints: [JointPoint]) -> FaceRegion? {
        let jointMap = Dictionary(uniqueKeysWithValues: joints.map { ($0.id, $0.location) })

        guard let nose = jointMap[.nose] else { return nil }

        if let leftEar = jointMap[.leftEar], let rightEar = jointMap[.rightEar] {
            let earSpan = hypot(leftEar.x - rightEar.x, leftEar.y - rightEar.y)
            let center = CGPoint(
                x: (nose.x + leftEar.x + rightEar.x) / 3,
                y: (nose.y + leftEar.y + rightEar.y) / 3
            )
            return FaceRegion(center: center, radius: max(earSpan * FaceMaskSizing.inferredEarSpanMultiplier, FaceMaskSizing.inferredMinimumRadius))
        }

        if let leftShoulder = jointMap[.leftShoulder], let rightShoulder = jointMap[.rightShoulder] {
            let shoulderSpan = hypot(leftShoulder.x - rightShoulder.x, leftShoulder.y - rightShoulder.y)
            return FaceRegion(center: nose, radius: max(shoulderSpan * FaceMaskSizing.inferredShoulderSpanMultiplier, FaceMaskSizing.inferredMinimumRadius))
        }

        return FaceRegion(center: nose, radius: FaceMaskSizing.inferredNoseFallbackRadius)
    }
}
