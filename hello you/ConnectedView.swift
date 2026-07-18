//
//  ConnectedView.swift
//  hello you
//
//  Screen 05 "Connected" from the Hello, you. design: just enough identity —
//  a name, a rating, three interests. The ground rules are the last thing
//  you read.
//

import SwiftUI

private let matchName = "Night Owl"
private let matchTags = ["Books", "Late nights", "Good listener"]
private let groundRules = [
    "This is for company, never dating.",
    "First names only. No numbers, no socials.",
    "Leave any time. One tap, no explanation.",
]

struct ConnectedView: View {
    @ObservedObject private var hyTheme = HYThemeStore.shared

    var body: some View {
        ZStack {
            HYColor.ink.ignoresSafeArea()
            RadialGradient(
                colors: [HYColor.warmTop, HYColor.ink],
                center: .top,
                startRadius: 0,
                endRadius: 420
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 5) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                    Text("Connected")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(2.16)
                        .textCase(.uppercase)
                }
                .foregroundColor(HYColor.green)
                .padding(.top, 24)

                matchCard
                    .padding(.horizontal, 26)
                    .padding(.top, 16)

                groundRulesBox
                    .padding(.horizontal, 26)
                    .padding(.top, 22)

                Spacer()

                NavigationLink {
                    CallView()
                } label: {
                    HStack(spacing: 9) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 16))
                        Text("Say hello")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .tracking(-0.16)
                    .foregroundColor(HYColor.onLavender)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(HYColor.lavFill, in: RoundedRectangle(cornerRadius: 27))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 26)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private var matchCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: -20) {
                HYAvatar(kind: .a1, size: 64, borderColor: HYColor.surface)
                    .zIndex(1)
                HYAvatar(kind: .a3, size: 64, borderColor: HYColor.surface)
            }
            .padding(.bottom, 20)

            Text(matchName)
                .font(.system(size: 24, weight: .semibold))
                .tracking(-0.72)
                .foregroundColor(HYColor.text)

            HStack(spacing: 5) {
                Image(systemName: "star.fill")
                    .font(.system(size: 11))
                Text("Verified · 4.9 conversation rating")
                    .font(.system(size: 11.5))
            }
            .foregroundColor(HYColor.lav)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(HYColor.lavSoft, in: Capsule())
            .padding(.top, 10)

            HStack(spacing: 7) {
                ForEach(matchTags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 12))
                        .foregroundColor(HYColor.dim)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(HYColor.surface2, in: Capsule())
                        .overlay(Capsule().stroke(HYColor.hair, lineWidth: 1))
                }
            }
            .padding(.top, 16)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 26)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: [HYColor.surface, HYColor.ink2], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 26)
        )
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(HYColor.hair, lineWidth: 1))
    }

    private var groundRulesBox: some View {
        VStack(alignment: .leading, spacing: 11) {
            ForEach(groundRules, id: \.self) { rule in
                HStack(alignment: .top, spacing: 10) {
                    Text("·")
                        .foregroundColor(HYColor.lav)
                    Text(rule)
                        .foregroundColor(HYColor.dim)
                        .lineSpacing(2)
                }
                .font(.system(size: 12.5))
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(HYColor.surface, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(HYColor.hair, lineWidth: 1))
    }
}

#Preview {
    NavigationStack {
        ConnectedView()
    }
}
