//
//  StreakCardView.swift
//  Squat Sensei
//

import SwiftUI

struct StreakCardView: View {
    let store: StreakStore

    var body: some View {
        HStack(spacing: 16) {
            flameIcon

            VStack(alignment: .leading, spacing: 4) {
                Text("Keep the streak alive!")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)

                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text("\(store.currentStreak)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("day streak")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }

            Spacer(minLength: 8)

            weekTracker
        }
        .padding(18)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var flameIcon: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.gold.opacity(0.35), lineWidth: 2)
                .frame(width: 52, height: 52)

            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundStyle(AppTheme.gold)
        }
    }

    private var weekTracker: some View {
        HStack(spacing: 8) {
            ForEach(store.weekDays) { day in
                VStack(spacing: 6) {
                    Text(day.label)
                        .font(.caption2)
                        .foregroundStyle(AppTheme.secondaryText)

                    if day.isCompleted {
                        ZStack {
                            Circle()
                                .fill(AppTheme.gold)
                                .frame(width: 22, height: 22)

                            Image(systemName: "checkmark")
                                .font(.caption2.bold())
                                .foregroundStyle(.black)
                        }
                    } else {
                        Circle()
                            .stroke(AppTheme.gold.opacity(0.6), lineWidth: 2)
                            .frame(width: 22, height: 22)
                    }
                }
            }
        }
    }
}

#Preview("Active streak") {
    StreakCardView(store: .preview(completedDateKeys: StreakCardPreviewData.sevenDayStreak))
        .padding()
        .background(AppTheme.background)
        .preferredColorScheme(.dark)
}

#Preview("Empty streak") {
    StreakCardView(store: .preview(completedDateKeys: []))
        .padding()
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
