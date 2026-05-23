//
//  FaceMaskPickerSheet.swift
//  Squat Sensei
//

import SwiftUI

struct FaceMaskPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedEmoji: String

    @State private var selectedCategory: FaceMaskCategory = .fun

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                LinearGradient(
                    colors: [AppTheme.gold.opacity(0.12), .clear],
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    categoryPicker
                    emojiGrid
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .navigationTitle("Choose Your Face Cover")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.gold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FaceMaskCategory.allCases) { category in
                    categoryPill(for: category)
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func categoryPill(for category: FaceMaskCategory) -> some View {
        let isSelected = category == selectedCategory

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedCategory = category
            }
        } label: {
            Text(category.rawValue)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? .black : AppTheme.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? AppTheme.gold : Color(red: 0.16, green: 0.16, blue: 0.16))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(isSelected ? AppTheme.gold : AppTheme.secondaryText.opacity(0.2), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }

    private var emojiGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(options(for: selectedCategory)) { option in
                    emojiCell(for: option)
                }
            }
            .padding(.bottom, 24)
        }
    }

    private func options(for category: FaceMaskCategory) -> [FaceMaskOption] {
        FaceMaskCatalog.categories.first { $0.0 == category }?.1 ?? []
    }

    private func emojiCell(for option: FaceMaskOption) -> some View {
        let isSelected = option.emoji == selectedEmoji

        return Button {
            select(option)
        } label: {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Text(option.emoji)
                        .font(.system(size: 34))
                        .frame(width: 64, height: 64)
                        .background(isSelected ? AppTheme.gold.opacity(0.16) : Color(red: 0.14, green: 0.14, blue: 0.14))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? AppTheme.gold : AppTheme.secondaryText.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                        }
                        .scaleEffect(isSelected ? 1.05 : 1)

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption.bold())
                            .foregroundStyle(AppTheme.gold)
                            .background(Circle().fill(Color.black))
                            .offset(x: 4, y: -4)
                    }
                }

                Text(option.label)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(isSelected ? AppTheme.gold : AppTheme.secondaryText)
                    .lineLimit(1)
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.75), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(option.label) face cover")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func select(_ option: FaceMaskOption) {
        selectedEmoji = option.emoji
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss()
    }
}

#Preview {
    FaceMaskPickerSheet(selectedEmoji: .constant(FaceMaskCatalog.default))
        .preferredColorScheme(.dark)
}
