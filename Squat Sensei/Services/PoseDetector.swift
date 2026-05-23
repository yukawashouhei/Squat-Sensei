//
//  PoseDetector.swift
//  Squat Sensei
//

import CoreMedia
import Vision

struct PoseDetector {
    private let request = VNDetectHumanBodyPoseRequest()
    private let confidenceThreshold: Float = 0.3

    func detect(in sampleBuffer: CMSampleBuffer) -> [JointPoint] {
        let handler = VNImageRequestHandler(
            cmSampleBuffer: sampleBuffer,
            orientation: .leftMirrored,
            options: [:]
        )

        do {
            try handler.perform([request])
        } catch {
            return []
        }

        guard let observation = request.results?.first else { return [] }

        var joints: [JointPoint] = []
        for jointName in observation.availableJointNames {
            guard let point = try? observation.recognizedPoint(jointName),
                  point.confidence >= confidenceThreshold else { continue }

            joints.append(
                JointPoint(
                    id: jointName,
                    location: CGPoint(x: point.location.x, y: 1 - point.location.y),
                    confidence: point.confidence
                )
            )
        }

        return joints
    }
}
