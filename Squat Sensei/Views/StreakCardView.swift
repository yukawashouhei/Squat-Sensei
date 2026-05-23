//
//  StreakCardView.swift
//  Squat Sensei
//

import SwiftUI

struct StreakCardView: View {
    let store: StreakStore

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            flameIcon
            streakText
            Spacer(minLength: 8)
            weekTracker
        }
        .padding(14)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var flameIcon: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.gold.opacity(0.35), lineWidth: 2)
                .frame(width: 40, height: 40)

            Image(systemName: "flame.fill")
                .font(.body)
                .foregroundStyle(AppTheme.gold)
        }
    }

    private var streakText: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Keep the streak alive!")
                .font(.caption2)
                .foregroundStyle(AppTheme.secondaryText)
                .lineLimit(1)

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text("\(store.currentStreak)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("day streak")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                    .lineLimit(1)
            }
        }
    }

    private var weekTracker: some View {
        HStack(spacing: 4) {
            ForEach(store.weekDays) { day in
                VStack(spacing: 4) {
                    Text(day.label)
                        .font(.caption2)
                        .foregroundStyle(AppTheme.secondaryText)
                        .frame(width: 16)

                    if day.isCompleted {
                        ZStack {
                            Circle()
                                .fill(AppTheme.gold)
                                .frame(width: 16, height: 16)

                            Image(systemName: "checkmark")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    } else {
                        Circle()
                            .stroke(AppTheme.gold.opacity(0.6), lineWidth: 2)
                            .frame(width: 16, height: 16)
                    }
                }
            }
        }
    }
}

#Preview("Active streak") {
    StreakCardView(store: .preview(completedDateKeys: StreakCardPreviewData.sevenDayStreak))
        .padding(.horizontal, 20)
        .frame(width: 390)
        .background(AppTheme.background)
        .preferredColorScheme(.dark)
}

#Preview("Empty streak") {
    StreakCardView(store: .preview(completedDateKeys: []))
        .padding(.horizontal, 20)
        .frame(width: 390)
        .background(AppTheme.background)
        .preferredColorScheme(.dark)
}

#if DEBUG
enum StreakCardPreviewData {
    static var sevenDayStreak: [String] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "yyyy-MM-dd"

        return (0..<6).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return formatter.string(from: date)
        }
    }
}
#endif
