//
//  FaceMask.swift
//  Squat Sensei
//

import CoreGraphics

struct FaceRegion: Sendable, Equatable {
    let center: CGPoint
    let radius: CGFloat
}

enum FaceMaskSizing {
    static let detectorRadiusMultiplier: CGFloat = 0.42
    static let overlayDiameterMultiplier: CGFloat = 1.35
    static let minOverlayFontSize: CGFloat = 22
    static let inferredEarSpanMultiplier: CGFloat = 0.40
    static let inferredShoulderSpanMultiplier: CGFloat = 0.26
    static let inferredNoseFallbackRadius: CGFloat = 0.06
    static let inferredMinimumRadius: CGFloat = 0.04
}

struct FaceMaskOption: Identifiable, Hashable {
    let id: String
    let emoji: String
    let label: String

    init(emoji: String, label: String) {
        self.id = emoji
        self.emoji = emoji
        self.label = label
    }
}

enum FaceMaskCategory: String, CaseIterable, Identifiable {
    case fun = "Fun"
    case cool = "Cool"
    case animals = "Animals"
    case fantasy = "Fantasy"

    var id: String { rawValue }
}

enum FaceMaskCatalog {
    static let `default` = "😊"

    static let categories: [(FaceMaskCategory, [FaceMaskOption])] = [
        (.fun, [
            FaceMaskOption(emoji: "😊", label: "Smile"),
            FaceMaskOption(emoji: "🥳", label: "Party"),
            FaceMaskOption(emoji: "🤪", label: "Silly"),
            FaceMaskOption(emoji: "😍", label: "Love"),
            FaceMaskOption(emoji: "🤩", label: "Star"),
            FaceMaskOption(emoji: "😛", label: "Playful")
        ]),
        (.cool, [
            FaceMaskOption(emoji: "😎", label: "Cool"),
            FaceMaskOption(emoji: "🥷", label: "Ninja"),
            FaceMaskOption(emoji: "🤠", label: "Cowboy"),
            FaceMaskOption(emoji: "🥸", label: "Disguise"),
            FaceMaskOption(emoji: "🎭", label: "Theater"),
            FaceMaskOption(emoji: "🤖", label: "Robot")
        ]),
        (.animals, [
            FaceMaskOption(emoji: "🦁", label: "Lion"),
            FaceMaskOption(emoji: "🐱", label: "Cat"),
            FaceMaskOption(emoji: "🐯", label: "Tiger"),
            FaceMaskOption(emoji: "🐻", label: "Bear"),
            FaceMaskOption(emoji: "🐼", label: "Panda"),
            FaceMaskOption(emoji: "🦊", label: "Fox")
        ]),
        (.fantasy, [
            FaceMaskOption(emoji: "👹", label: "Oni"),
            FaceMaskOption(emoji: "👽", label: "Alien"),
            FaceMaskOption(emoji: "👻", label: "Ghost"),
            FaceMaskOption(emoji: "🎃", label: "Pumpkin"),
            FaceMaskOption(emoji: "🧛", label: "Vampire"),
            FaceMaskOption(emoji: "🧙", label: "Wizard")
        ])
    ]

    static var allOptions: [FaceMaskOption] {
        categories.flatMap(\.1)
    }

    static var emojis: [String] {
        allOptions.map(\.emoji)
    }

    static func option(for emoji: String) -> FaceMaskOption? {
        allOptions.first { $0.emoji == emoji }
    }
}

enum FaceMaskStorageKey {
    static let emoji = "faceMaskEmoji"
}
