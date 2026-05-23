//
//  FaceDetector.swift
//  Squat Sensei
//

import CoreGraphics
import CoreMedia
import Vision

struct FaceDetector {
    private let request = VNDetectFaceRectanglesRequest()

    func detect(in sampleBuffer: CMSampleBuffer) -> FaceRegion? {
        let handler = VNImageRequestHandler(
            cmSampleBuffer: sampleBuffer,
            orientation: .leftMirrored,
            options: [:]
        )

        do {
            try handler.perform([request])
        } catch {
            return nil
        }

        guard let observation = request.results?.first else { return nil }

        let bbox = observation.boundingBox
        let center = CGPoint(x: bbox.midX, y: 1 - bbox.midY)
        let radius = max(bbox.width, bbox.height) * FaceMaskSizing.detectorRadiusMultiplier

        return FaceRegion(center: center, radius: radius)
    }
}
