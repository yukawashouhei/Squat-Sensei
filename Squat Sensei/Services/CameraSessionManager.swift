//
//  CameraSessionManager.swift
//  Squat Sensei
//

import AVFoundation

final class CameraSessionManager: NSObject, @unchecked Sendable {
    let session = AVCaptureSession()

    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "com.perksh.squat-sensei.camera")
    private var isConfigured = false
    private var sampleBufferHandler: ((CMSampleBuffer) -> Void)?

    var isRunning: Bool {
        session.isRunning
    }

    func setSampleBufferHandler(_ handler: ((CMSampleBuffer) -> Void)?) {
        sessionQueue.async { [weak self] in
            self?.sampleBufferHandler = handler
        }
    }

    func requestPermission() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        default:
            return false
        }
    }

    func configure(usingFrontCamera: Bool = true) throws {
        var configurationError: Error?

        sessionQueue.sync {
            do {
                try self.configureSession(usingFrontCamera: usingFrontCamera)
            } catch {
                configurationError = error
            }
        }

        if let configurationError {
            throw configurationError
        }
    }

    func start() {
        sessionQueue.async { [weak self] in
            guard let self, self.isConfigured, !self.session.isRunning else { return }
            self.session.startRunning()
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }

    private func configureSession(usingFrontCamera: Bool) throws {
        session.beginConfiguration()
        defer { session.commitConfiguration() }

        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }

        session.sessionPreset = .high

        let position: AVCaptureDevice.Position = usingFrontCamera ? .front : .back
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            throw CameraError.deviceUnavailable
        }

        session.addInput(input)

        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)

        guard session.canAddOutput(videoOutput) else {
            throw CameraError.outputUnavailable
        }

        session.addOutput(videoOutput)
        isConfigured = true
    }
}

extension CameraSessionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        sampleBufferHandler?(sampleBuffer)
    }
}

enum CameraError: Error {
    case deviceUnavailable
    case outputUnavailable
}
