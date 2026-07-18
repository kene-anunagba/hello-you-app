//
//  SettingsView.swift
//  hello you
//
//  Screen 11 "Settings" from the Hello, you. design: appearance sits up
//  top — Cream or Dark, your call. Age is off by default, on purpose.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var hyTheme = HYThemeStore.shared

    @State private var showMyAge = false
    @State private var quietHours = true

    var body: some View {
        ZStack {
            HYColor.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("You")
                        .font(.system(size: 17, weight: .semibold))
                        .tracking(-0.34)
                        .foregroundColor(HYColor.text)
                    Spacer()
                    Button { dismiss() } label: {
                        Circle()
                            .fill(HYColor.surface2)
                            .frame(width: 34, height: 34)
                            .overlay(
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(HYColor.text)
                            )
                            .overlay(Circle().stroke(HYColor.hair, lineWidth: 1))
                    }
                    .accessibilityLabel("Close Settings")
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 26)
                .padding(.top, 6)
                .padding(.bottom, 14)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        meCard
                            .padding(.horizontal, 26)
                            .padding(.top, 4)

                        HYGroupLabel(text: "Appearance")
                            .padding(.horizontal, 26)
                            .padding(.top, 24)
                            .padding(.bottom, 10)

                        appearanceCard
                            .padding(.horizontal, 26)

                        HYGroupLabel(text: "Your identity")
                            .padding(.horizontal, 26)
                            .padding(.top, 24)
                            .padding(.bottom, 10)

                        HYRowGroup {
                            HYRow(systemImage: "person.crop.circle", title: "Display name", showTopBorder: false) {
                                HStack(spacing: 8) {
                                    Text("Noah").font(.system(size: 14)).foregroundColor(HYColor.dim)
                                    HYChevron()
                                }
                            }
                            HYRow(systemImage: "circle.grid.2x2", title: "Avatar") {
                                HStack(spacing: 8) {
                                    HYAvatar(kind: .a2, size: 22)
                                    HYChevron()
                                }
                            }
                            HYRow(systemImage: "line.3.horizontal", title: "Interests") {
                                HStack(spacing: 8) {
                                    Text("Books, AI, Travel").font(.system(size: 14)).foregroundColor(HYColor.dim)
                                    HYChevron()
                                }
                            }
                        }
                        .id(hyTheme.isDark)
                        .padding(.horizontal, 26)

                        HYGroupLabel(text: "Privacy")
                            .padding(.horizontal, 26)
                            .padding(.top, 24)
                            .padding(.bottom, 10)

                        HYRowGroup {
                            HYRow(
                                systemImage: "shield",
                                title: "Show my age",
                                subtitle: "Off. Companionship, not dating",
                                showTopBorder: false
                            ) {
                                Toggle("", isOn: $showMyAge)
                                    .labelsHidden()
                                    .tint(HYColor.lav)
                            }
                            HYRow(
                                systemImage: "moon.zzz",
                                title: "Quiet hours",
                                subtitle: "No matches 11pm–7am"
                            ) {
                                Toggle("", isOn: $quietHours)
                                    .labelsHidden()
                                    .tint(HYColor.lav)
                            }
                        }
                        .padding(.horizontal, 26)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private var meCard: some View {
        HStack(spacing: 16) {
            HYAvatar(kind: .a2, size: 56)

            VStack(alignment: .leading, spacing: 3) {
                Text("Noah")
                    .font(.system(size: 20, weight: .semibold))
                    .tracking(-0.4)
                    .foregroundColor(HYColor.text)
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(HYColor.lav)
                    Text("Verified · 4.8 rating")
                        .font(.system(size: 12.5))
                        .foregroundColor(HYColor.dim)
                }
            }

            Spacer()

            HYChevron()
        }
        .padding(20)
        .background(
            LinearGradient(colors: [HYColor.surface, HYColor.ink2], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(HYColor.hair, lineWidth: 1))
    }

    private var appearanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 3) {
                segButton(title: "Cream", isOn: !hyTheme.isDark) {
                    hyTheme.isDark = false
                }
                segButton(title: "Dark", isOn: hyTheme.isDark) {
                    hyTheme.isDark = true
                }
            }
            .padding(3)
            .background(HYColor.surface2, in: RoundedRectangle(cornerRadius: 13))

            Text("Pick the background that feels calmest to you.")
                .font(.system(size: 12))
                .foregroundColor(HYColor.dim)
        }
        .padding(14)
        .background(HYColor.surface, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(HYColor.hair, lineWidth: 1))
    }

    private func segButton(title: String, isOn: Bool, action: @escaping () -> Void) -> some View {
        // Deliberately not wrapped in withAnimation: hyTheme is a shared
        // singleton every screen in the app observes, so animating this
        // would try to cross-fade the entire, mostly-offscreen view
        // hierarchy in one transaction. An instant flip is the safe choice.
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .tracking(-0.13)
                .foregroundColor(isOn ? HYColor.text : HYColor.dim)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(isOn ? HYColor.surface : Color.clear, in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
