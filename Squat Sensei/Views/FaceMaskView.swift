//
//  FaceMaskView.swift
//  Squat Sensei
//

import SwiftUI

struct FaceMaskView: View {
    let region: FaceRegion?
    let emoji: String

    var body: some View {
        GeometryReader { geometry in
            if let region {
                let size = region.radius * FaceMaskSizing.overlayDiameterMultiplier * geometry.size.width
                let position = CGPoint(
                    x: region.center.x * geometry.size.width,
                    y: region.center.y * geometry.size.height
                )

                Text(emoji)
                    .font(.system(size: max(size, FaceMaskSizing.minOverlayFontSize)))
                    .position(position)
                    .animation(.easeOut(duration: 0.12), value: region)
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    ZStack {
        Color.black
        FaceMaskView(
            region: FaceRegion(center: CGPoint(x: 0.5, y: 0.25), radius: 0.12),
            emoji: "😊"
        )
    }
    .ignoresSafeArea()
}
