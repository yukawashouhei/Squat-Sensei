//
//  SquatSessionView.swift
//  Squat Sensei
//

import SwiftUI

struct SquatSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(FaceMaskStorageKey.emoji) private var faceMaskEmoji = FaceMaskCatalog.default
    @State private var viewModel = SquatSessionViewModel()

    var body: some View {
        ZStack {
            if viewModel.permissionDenied {
                permissionDeniedView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else {
                sessionContent
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }

    private var sessionContent: some View {
        ZStack {
            CameraPreviewView(session: viewModel.cameraManager.session)
                .ignoresSafeArea()

            FaceMaskView(region: viewModel.face, emoji: faceMaskEmoji)
                .ignoresSafeArea()

            PoseOverlayView(joints: viewModel.joints)
                .ignoresSafeArea()

            LinearGradient(
                colors: [.black.opacity(0.65), .clear, .black.opacity(0.75)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack {
                HStack {
                    Spacer()
                    Button {
                        viewModel.stop()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.black.opacity(0.45))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()

                VStack(spacing: 16) {
                    Text(viewModel.displayCount)
                        .font(.system(size: 96, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.gold)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    Text(viewModel.caption)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    if viewModel.isSessionComplete {
                        Text("Session complete")
                            .font(.headline)
                            .foregroundStyle(AppTheme.gold)
                    }
                }
                .padding(.bottom, 40)

                HStack {
                    Spacer()
                    Button {
                        Task {
                            await viewModel.toggleCamera()
                        }
                    } label: {
                        Image(systemName: "camera.rotate")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .frame(width: 48, height: 48)
                            .background(.black.opacity(0.45))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
    }

    private var permissionDeniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.gold)

            Text("Camera access is required")
                .font(.title2.bold())
                .foregroundStyle(.white)

            Text("Enable camera access in Settings to start your squat session.")
                .font(.body)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button("Close") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.gold)
        }
        .padding()
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.title3)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Button("Close") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.gold)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        SquatSessionView()
    }
    .preferredColorScheme(.dark)
}
