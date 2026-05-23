//
//  FaceMaskPickerView.swift
//  Squat Sensei
//

import SwiftUI

struct FaceMaskPickerView: View {
    @AppStorage(FaceMaskStorageKey.emoji) private var selectedEmoji = FaceMaskCatalog.default
    @State private var isPickerPresented = false

    private var selectedLabel: String {
        FaceMaskCatalog.option(for: selectedEmoji)?.label ?? "Smile"
    }

    var body: some View {
        Button {
            isPickerPresented = true
        } label: {
            HStack(spacing: 16) {
                selectedEmojiBadge

                VStack(alignment: .leading, spacing: 4) {
                    Text("Face Cover")
                        .font(.headline.bold())
                        .foregroundStyle(.white)

                    Text("Tap to choose your mask")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(selectedLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.gold)

                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.gold)
                }
            }
            .padding(18)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isPickerPresented) {
            FaceMaskPickerSheet(selectedEmoji: $selectedEmoji)
        }
    }

    private var selectedEmojiBadge: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.gold.opacity(0.45), lineWidth: 2)
                .frame(width: 56, height: 56)

            Text(selectedEmoji)
                .font(.system(size: 30))
        }
    }
}

#Preview {
    FaceMaskPickerView()
        .padding()
        .background(AppTheme.background)
        .preferredColorScheme(.dark)
}
