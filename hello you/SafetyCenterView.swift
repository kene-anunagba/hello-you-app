//
//  SafetyCenterView.swift
//  hello you
//
//  Screen 12 "Safety Center" from the Hello, you. design: the
//  highest-priority surface. Report & leave sits first and coloured,
//  where a thumb can find it fast.
//

import SwiftUI

struct SafetyCenterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var hyTheme = HYThemeStore.shared

    @State private var aiModeration = true

    var body: some View {
        ZStack {
            HYColor.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(HYColor.dim)
                            .frame(width: 34, height: 34)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Back")

                    Spacer()

                    Text("Safety Center")
                        .font(.system(size: 17, weight: .semibold))
                        .tracking(-0.34)
                        .foregroundColor(HYColor.text)

                    Spacer()

                    Color.clear.frame(width: 34, height: 34)
                }
                .padding(.horizontal, 26)
                .padding(.top, 6)
                .padding(.bottom, 6)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [HYColor.green.opacity(0.35), HYColor.green.opacity(0.08)],
                                            center: UnitPoint(x: 0.4, y: 0.3),
                                            startRadius: 0,
                                            endRadius: 40
                                        )
                                    )
                                    .overlay(Circle().stroke(HYColor.green.opacity(0.3), lineWidth: 1))
                                Image(systemName: "checkmark.shield")
                                    .font(.system(size: 26))
                                    .foregroundColor(HYColor.green)
                            }
                            .frame(width: 64, height: 64)
                            .padding(.bottom, 18)

                            Text("You're in control.")
                                .font(.system(size: 22, weight: .semibold))
                                .tracking(-0.66)
                                .foregroundColor(HYColor.text)

                            Text("Every conversation is protected. Leaving is always one tap away.")
                                .font(.system(size: 13.5))
                                .foregroundColor(HYColor.dim)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                                .padding(.top, 8)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 14)
                        .padding(.bottom, 6)

                        HYRowGroup {
                            HYRow(
                                systemImage: "exclamationmark.triangle",
                                title: "Report & leave",
                                subtitle: "Ends instantly, flags for review",
                                iconColor: HYColor.red,
                                showTopBorder: false
                            ) {
                                HYChevron()
                            }

                            HYRow(
                                systemImage: "person.crop.circle.badge.checkmark",
                                title: "AI moderation",
                                subtitle: "Listens for harm, never stores"
                            ) {
                                Toggle("", isOn: $aiModeration)
                                    .labelsHidden()
                                    .tint(HYColor.lav)
                            }

                            HYRow(
                                systemImage: "star",
                                title: "Verify my identity",
                                subtitle: "Adds a badge · stays private"
                            ) {
                                HStack(spacing: 8) {
                                    Text("Get badge").font(.system(size: 13)).foregroundColor(HYColor.faint)
                                    HYChevron()
                                }
                            }

                            HYRow(
                                systemImage: "person.2.slash",
                                title: "Blocked people",
                                subtitle: "They can never be matched to you"
                            ) {
                                HStack(spacing: 8) {
                                    Text("3").font(.system(size: 13)).foregroundColor(HYColor.faint)
                                    HYChevron()
                                }
                            }
                        }
                        .id(hyTheme.isDark)
                        .padding(.horizontal, 26)
                        .padding(.top, 20)

                        Text("No unsolicited messages, ever. Someone can only reach you if you both chose to talk again.")
                            .font(.system(size: 11.5))
                            .foregroundColor(HYColor.faint)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 26)
                            .padding(.top, 16)
                            .padding(.bottom, 24)
                    }
                }
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SafetyCenterView()
    }
}
