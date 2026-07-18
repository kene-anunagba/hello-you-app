//
//  PremiumView.swift
//  hello you
//
//  Screen 13 "Hello, you. +" from the Hello, you. design: premium sells
//  time and presence, never reach or status. It stays true to the promise.
//

import SwiftUI

private struct PremiumFeature {
    let systemImage: String
    let title: String
    let detail: String
}

private let premiumFeatures = [
    PremiumFeature(systemImage: "bolt.fill", title: "Priority matching", detail: "Skip the queue at 2am, when it matters most"),
    PremiumFeature(systemImage: "clock", title: "Longer sessions", detail: "Start at 40 minutes instead of 20"),
    PremiumFeature(systemImage: "star.fill", title: "Choose the mood you meet", detail: "Filter for listeners, thinkers, or comics"),
    PremiumFeature(systemImage: "person.crop.circle", title: "Custom avatars", detail: "A wider set of quiet, abstract palettes"),
]

struct PremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var hyTheme = HYThemeStore.shared

    var body: some View {
        ZStack {
            HYColor.ink.ignoresSafeArea()
            RadialGradient(
                colors: [HYColor.lavFill.opacity(0.18), Color.clear],
                center: .top,
                startRadius: 0,
                endRadius: 420
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(HYColor.dim)
                            .frame(width: 34, height: 34)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 22)
                .padding(.top, 6)

                HStack(spacing: 8) {
                    (
                        Text("Hello").foregroundColor(HYColor.text)
                        + Text(",").foregroundColor(HYColor.lav)
                        + Text(" you.").foregroundColor(HYColor.text)
                    )
                    .font(.system(size: 26, weight: .semibold))
                    .tracking(-0.78)

                    Text("+")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(HYColor.lav)
                }
                .padding(.top, 14)

                Text("For the nights you'd rather not spend alone.")
                    .font(.system(size: 14))
                    .foregroundColor(HYColor.dim)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 40)
                    .padding(.top, 6)

                VStack(spacing: 2) {
                    ForEach(premiumFeatures.indices, id: \.self) { i in
                        HStack(alignment: .top, spacing: 14) {
                            Image(systemName: premiumFeatures[i].systemImage)
                                .font(.system(size: 18))
                                .foregroundColor(HYColor.lav)
                                .frame(width: 20)
                                .padding(.top, 1)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(premiumFeatures[i].title)
                                    .font(.system(size: 14.5, weight: .medium))
                                    .foregroundColor(HYColor.text)
                                Text(premiumFeatures[i].detail)
                                    .font(.system(size: 12.5))
                                    .foregroundColor(HYColor.dim)
                                    .lineSpacing(2)
                            }
                        }
                        .padding(.vertical, 13)
                        .overlay(alignment: .top) {
                            if i > 0 {
                                Rectangle().fill(HYColor.hair).frame(height: 1)
                            }
                        }
                    }
                }
                .padding(.horizontal, 26)
                .padding(.top, 26)

                Spacer()

                VStack(spacing: 0) {
                    Text("7 days free, then")
                        .font(.system(size: 13))
                        .foregroundColor(HYColor.dim)

                    Text("$11.99 / month")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(HYColor.text)
                        .padding(.top, 2)

                    Button {
                        // Try it free
                    } label: {
                        Text("Try it free")
                            .font(.system(size: 16, weight: .semibold))
                            .tracking(-0.16)
                            .foregroundColor(HYColor.onLavender)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(HYColor.lavFill, in: RoundedRectangle(cornerRadius: 27))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 14)

                    Text("Cancel anytime · Restore purchase")
                        .font(.system(size: 11))
                        .foregroundColor(HYColor.faint)
                        .padding(.top, 12)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 26)
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        PremiumView()
    }
}
