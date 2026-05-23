//
//  SquatCounter.swift
//  Squat Sensei
//

import CoreGraphics
import Vision

enum SquatPhase {
    case standing
    case descending
    case bottom
    case ascending
}

struct SquatCounter {
    private(set) var repCount = 0
    private var phase: SquatPhase = .standing

    private let descendingThreshold: CGFloat = 140
    private let bottomThreshold: CGFloat = 100
    private let ascendingThreshold: CGFloat = 120
    private let standingThreshold: CGFloat = 160

    mutating func reset() {
        repCount = 0
        phase = .standing
    }

    /// Returns the new rep count if a rep was completed this frame.
    mutating func process(joints: [JointPoint]) -> Int? {
        guard let kneeAngle = averageKneeAngle(from: joints) else { return nil }

        switch phase {
        case .standing:
            if kneeAngle < descendingThreshold {
                phase = .descending
            }
        case .descending:
            if kneeAngle < bottomThreshold {
                phase = .bottom
            } else if kneeAngle >= standingThreshold {
                phase = .standing
            }
        case .bottom:
            if kneeAngle > ascendingThreshold {
                phase = .ascending
            }
        case .ascending:
            if kneeAngle >= standingThreshold {
                phase = .standing
                repCount += 1
                return repCount
            } else if kneeAngle < bottomThreshold {
                phase = .bottom
            }
        }

        return nil
    }

    private func averageKneeAngle(from joints: [JointPoint]) -> CGFloat? {
        let map = Dictionary(uniqueKeysWithValues: joints.map { ($0.id, $0.location) })
        var angles: [CGFloat] = []

        if let angle = kneeAngle(hip: .leftHip, knee: .leftKnee, ankle: .leftAnkle, in: map) {
            angles.append(angle)
        }
        if let angle = kneeAngle(hip: .rightHip, knee: .rightKnee, ankle: .rightAnkle, in: map) {
            angles.append(angle)
        }

        guard !angles.isEmpty else { return nil }
        return angles.reduce(0, +) / CGFloat(angles.count)
    }

    private func kneeAngle(
        hip: VNHumanBodyPoseObservation.JointName,
        knee: VNHumanBodyPoseObservation.JointName,
        ankle: VNHumanBodyPoseObservation.JointName,
        in map: [VNHumanBodyPoseObservation.JointName: CGPoint]
    ) -> CGFloat? {
        guard let hipPoint = map[hip],
              let kneePoint = map[knee],
              let anklePoint = map[ankle] else { return nil }
        return Self.angle(at: kneePoint, from: hipPoint, to: anklePoint)
    }

    private static func angle(at vertex: CGPoint, from a: CGPoint, to b: CGPoint) -> CGFloat {
        let v1 = CGVector(dx: a.x - vertex.x, dy: a.y - vertex.y)
        let v2 = CGVector(dx: b.x - vertex.x, dy: b.y - vertex.y)
        let dot = v1.dx * v2.dx + v1.dy * v2.dy
        let mag1 = hypot(v1.dx, v1.dy)
        let mag2 = hypot(v2.dx, v2.dy)
        guard mag1 > 0, mag2 > 0 else { return 180 }
        let cosAngle = max(-1, min(1, dot / (mag1 * mag2)))
        return acos(cosAngle) * 180 / .pi
    }
}
