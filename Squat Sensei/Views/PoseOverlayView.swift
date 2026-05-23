//
//  PoseOverlayView.swift
//  Squat Sensei
//

import SwiftUI
import Vision

struct PoseOverlayView: View {
    let joints: [JointPoint]

    var body: some View {
        Canvas { context, size in
            let jointMap = Dictionary(uniqueKeysWithValues: joints.map { ($0.id, $0.location) })

            for (start, end) in SkeletonEdges.connections {
                guard let startPoint = jointMap[start],
                      let endPoint = jointMap[end] else { continue }

                var path = Path()
                path.move(to: scaledPoint(startPoint, in: size))
                path.addLine(to: scaledPoint(endPoint, in: size))

                context.stroke(
                    path,
                    with: .color(AppTheme.skeletonGreen),
                    lineWidth: 4
                )
            }

            for joint in joints {
                let center = scaledPoint(joint.location, in: size)
                let dot = Path(ellipseIn: CGRect(x: center.x - 5, y: center.y - 5, width: 10, height: 10))
                context.fill(dot, with: .color(AppTheme.skeletonGreen))
            }
        }
        .allowsHitTesting(false)
    }

    private func scaledPoint(_ point: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(x: point.x * size.width, y: point.y * size.height)
    }
}

#Preview {
    PoseOverlayView(joints: [
        JointPoint(id: .leftShoulder, location: CGPoint(x: 0.35, y: 0.25), confidence: 1),
        JointPoint(id: .rightShoulder, location: CGPoint(x: 0.65, y: 0.25), confidence: 1),
        JointPoint(id: .leftHip, location: CGPoint(x: 0.4, y: 0.5), confidence: 1),
        JointPoint(id: .rightHip, location: CGPoint(x: 0.6, y: 0.5), confidence: 1),
        JointPoint(id: .leftKnee, location: CGPoint(x: 0.38, y: 0.7), confidence: 1),
        JointPoint(id: .rightKnee, location: CGPoint(x: 0.62, y: 0.7), confidence: 1),
        JointPoint(id: .leftAnkle, location: CGPoint(x: 0.36, y: 0.9), confidence: 1),
        JointPoint(id: .rightAnkle, location: CGPoint(x: 0.64, y: 0.9), confidence: 1)
    ])
    .frame(width: 300, height: 500)
    .background(Color.black)
}
