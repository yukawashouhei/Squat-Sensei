//
//  SquatSessionViewModel.swift
//  Squat Sensei
//

import AVFoundation
import Observation

@MainActor
@Observable
final class SquatSessionViewModel {
    var joints: [JointPoint] = []
    var displayCount = "0"
    var caption = "Get ready. Squat down and stand up."
    var isSessionComplete = false
    var permissionDenied = false
    var errorMessage: String?

    let cameraManager = CameraSessionManager()

    private let frameProcessor = FrameProcessor()
    private let speechCoach = SpeechCoach()
    private var usesFrontCamera = true

    func start() async {
        permissionDenied = false
        errorMessage = nil
        isSessionComplete = false
        frameProcessor.reset()
        displayCount = "0"
        caption = "Get ready. Squat down and stand up."
        joints = []

        guard await cameraManager.requestPermission() else {
            permissionDenied = true
            return
        }

        do {
            try cameraManager.configure(usingFrontCamera: usesFrontCamera)
            cameraManager.setSampleBufferHandler { [frameProcessor] sampleBuffer in
                let result = frameProcessor.process(sampleBuffer)
                Task { @MainActor [weak self] in
                    self?.applyFrameResult(result)
                }
            }
            cameraManager.start()
        } catch {
            errorMessage = "Unable to start the camera."
        }
    }

    func stop() {
        cameraManager.setSampleBufferHandler(nil)
        cameraManager.stop()
        speechCoach.stop()
    }

    func toggleCamera() async {
        usesFrontCamera.toggle()
        cameraManager.stop()

        do {
            try cameraManager.configure(usingFrontCamera: usesFrontCamera)
            cameraManager.start()
        } catch {
            errorMessage = "Unable to switch the camera."
        }
    }

    private func applyFrameResult(_ result: FrameAnalysisResult) {
        guard !isSessionComplete else { return }

        joints = result.joints

        if let completedRep = result.completedRep {
            handleCompletedRep(completedRep)
        }
    }

    private func handleCompletedRep(_ rep: Int) {
        guard let line = SquatCoachScript.line(for: rep) else { return }

        displayCount = line.displayCount
        if !line.caption.isEmpty {
            caption = line.caption
        }

        speechCoach.speak(line.spoken)

        if rep >= SquatCoachScript.totalReps {
            isSessionComplete = true
            cameraManager.stop()
            StreakStore.shared.markTodayCompleted()
        }
    }
}
