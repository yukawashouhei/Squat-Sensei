//
//  HomeView.swift
//  Squat Sensei
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                heroSection
                todaysWorkoutSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var heroSection: some View {
        Image("hero_samurai")
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var todaysWorkoutSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Today's Workout")
                .font(.title2.bold())
                .foregroundStyle(.white)

            NavigationLink {
                SquatSessionView()
            } label: {
                squatSessionCard
            }
            .buttonStyle(.plain)
        }
    }

    private var squatSessionCard: some View {
        HStack(spacing: 16) {
            Image("squat_session_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 6) {
                Text("Squat Session")
                    .font(.headline.bold())
                    .foregroundStyle(.white)

                Text("Focus: Lower Body Strength")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)

                HStack(spacing: 16) {
                    Label("10 Reps", systemImage: "repeat")
                    Label("~10 min", systemImage: "clock")
                }
                .font(.caption)
                .foregroundStyle(AppTheme.gold)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(AppTheme.gold)
        }
        .padding(18)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .preferredColorScheme(.dark)
}
