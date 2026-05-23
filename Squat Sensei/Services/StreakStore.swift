//
//  StreakStore.swift
//  Squat Sensei
//

import Foundation
import Observation

struct WeekDayStatus: Identifiable {
    let id: String
    let label: String
    let isCompleted: Bool
}

@MainActor
@Observable
final class StreakStore {
    static let shared = StreakStore()

    private(set) var completedDates: Set<String> = []

    private let defaults: UserDefaults
    private let storageKey = "streakCompletedDates"
    private let calendar: Calendar

    init(defaults: UserDefaults = .standard, calendar: Calendar = .current) {
        self.defaults = defaults
        var configuredCalendar = calendar
        configuredCalendar.firstWeekday = 2
        self.calendar = configuredCalendar
        reload()
    }

    func reload() {
        if let saved = defaults.stringArray(forKey: storageKey) {
            completedDates = Set(saved)
        } else {
            completedDates = []
        }
    }

    func markTodayCompleted() {
        let key = dateKey(for: Date())
        guard !completedDates.contains(key) else { return }
        completedDates.insert(key)
        persist()
    }

    func isCompleted(on date: Date) -> Bool {
        completedDates.contains(dateKey(for: date))
    }

    var currentStreak: Int {
        let today = calendar.startOfDay(for: Date())
        let startDate: Date

        if isCompleted(on: today) {
            startDate = today
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                  isCompleted(on: yesterday) {
            startDate = yesterday
        } else {
            return 0
        }

        var streak = 0
        var cursor = startDate

        while isCompleted(on: cursor) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }

        return streak
    }

    var weekDays: [WeekDayStatus] {
        let labels = ["M", "T", "W", "T", "F", "S", "S"]
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return []
        }

        return labels.enumerated().map { index, label in
            let date = calendar.date(byAdding: .day, value: index, to: monday) ?? today
            return WeekDayStatus(
                id: dateKey(for: date),
                label: label,
                isCompleted: isCompleted(on: date)
            )
        }
    }

    private func persist() {
        defaults.set(Array(completedDates), forKey: storageKey)
    }

    private func dateKey(for date: Date) -> String {
        let day = calendar.startOfDay(for: date)
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: day)
    }
}

#if DEBUG
extension StreakStore {
    static func preview(completedDateKeys: [String]) -> StreakStore {
        let suiteName = "StreakStorePreview-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.set(completedDateKeys, forKey: "streakCompletedDates")
        return StreakStore(defaults: defaults)
    }
}
#endif
