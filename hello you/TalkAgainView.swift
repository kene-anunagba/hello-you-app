//
//  TalkAgainView.swift
//  hello you
//
//  Screen 10 "Talk again" from the Hello, you. design: the only path to a
//  repeat conversation is double opt-in, so no one is ever pursued.
//

import SwiftUI

struct TalkAgainView: View {
    @ObservedObject private var hyTheme = HYThemeStore.shared
    @State private var didRespond = false
    @State private var saidYes = false

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
                Spacer()

                VStack(spacing: 0) {
                    HStack(spacing: -12) {
                        HYAvatar(kind: .a1, size: 70, borderColor: HYColor.ink)
                            .zIndex(1)
                        HYAvatar(kind: .a3, size: 70, borderColor: HYColor.ink)
                    }
                    .padding(.bottom, 24)

                    Text("Talk again?")
                        .font(.system(size: 26, weight: .semibold))
                        .tracking(-0.78)
                        .foregroundColor(HYColor.text)

                    Text("If you'd like to reach Night Owl another time, tap below. They'll never know unless they choose it too.")
                        .font(.system(size: 15))
                        .foregroundColor(HYColor.dim)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .frame(maxWidth: 250)
                        .padding(.top, 12)

                    HStack(spacing: 8) {
                        mutualStatus(name: "You", isConfirmed: saidYes)
                        Text("·").foregroundColor(HYColor.faint)
                        mutualStatus(name: "Night Owl", isConfirmed: false)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 30)

                Spacer()

                VStack(spacing: 11) {
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            didRespond = true
                            saidYes = true
                        }
                    } label: {
                        Text("Yes, I'd talk again")
                            .font(.system(size: 16, weight: .semibold))
                            .tracking(-0.16)
                            .foregroundColor(HYColor.onLavender)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(HYColor.lavFill, in: RoundedRectangle(cornerRadius: 27))
                    }
                    .buttonStyle(.plain)
                    .disabled(didRespond)
                    .opacity(didRespond ? 0.6 : 1)

                    Button {
                        withAnimation(.easeOut(duration: 0.2)) { didRespond = true }
                    } label: {
                        Text("No thanks")
                            .font(.system(size: 16, weight: .semibold))
                            .tracking(-0.16)
                            .foregroundColor(HYColor.text)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(HYColor.surface2, in: RoundedRectangle(cornerRadius: 27))
                            .overlay(RoundedRectangle(cornerRadius: 27).stroke(HYColor.hair, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .disabled(didRespond)
                    .opacity(didRespond ? 0.6 : 1)

                    Text(didRespond ? "Saved. If Night Owl says yes too, you'll both be notified." : "A match only opens if you both say yes.")
                        .font(.system(size: 11.5))
                        .foregroundColor(HYColor.faint)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private func mutualStatus(name: String, isConfirmed: Bool) -> some View {
        HStack(spacing: 5) {
            Text(name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(HYColor.text)
            ZStack {
                if isConfirmed {
                    Circle().fill(HYColor.lavFill)
                    Image(systemName: "checkmark")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(HYColor.onLavender)
                } else {
                    Circle().stroke(HYColor.faint, lineWidth: 2)
                }
            }
            .frame(width: 12, height: 12)
        }
    }
}

#Preview {
    NavigationStack {
        TalkAgainView()
    }
}
