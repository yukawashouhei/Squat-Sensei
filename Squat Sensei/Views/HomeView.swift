//
//  HomeView.swift
//  Squat Sensei
//

import SwiftUI
import UIKit

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
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("Squat Sensei")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .italic()
                        .foregroundStyle(.white)

                    Text("先生")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(AppTheme.redAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }

                Text("MASTER THE SQUAT.\nBUILD STRENGTH. BUILD YOU.")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(4)
            }

            Spacer(minLength: 0)

            ZStack {
                Circle()
                    .fill(AppTheme.redAccent)
                    .frame(width: 120, height: 120)
                    .offset(x: 8, y: 8)

                heroImage
                    .frame(width: 110, height: 110)
            }
        }
    }

    @ViewBuilder
    private var heroImage: some View {
        if UIImage(named: "hero_samurai") != nil {
            Image("hero_samurai")
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: "figure.strengthtraining.functional")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .padding(16)
        }
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
            Image(systemName: "figure.strengthtraining.functional")
                .font(.system(size: 36))
                .foregroundStyle(AppTheme.gold)
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
