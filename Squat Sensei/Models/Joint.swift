//
//  Joint.swift
//  Squat Sensei
//

import CoreGraphics
import Vision

struct JointPoint: Identifiable, Sendable {
    let id: VNHumanBodyPoseObservation.JointName
    let location: CGPoint
    let confidence: Float
}

enum SkeletonEdges {
    static let connections: [(VNHumanBodyPoseObservation.JointName, VNHumanBodyPoseObservation.JointName)] = [
        (.leftShoulder, .rightShoulder),
        (.leftShoulder, .leftHip),
        (.rightShoulder, .rightHip),
        (.leftHip, .rightHip),
        (.leftHip, .leftKnee),
        (.leftKnee, .leftAnkle),
        (.rightHip, .rightKnee),
        (.rightKnee, .rightAnkle),
        (.leftShoulder, .leftElbow),
        (.leftElbow, .leftWrist),
        (.rightShoulder, .rightElbow),
        (.rightElbow, .rightWrist),
        (.neck, .leftShoulder),
        (.neck, .rightShoulder)
    ]
}
