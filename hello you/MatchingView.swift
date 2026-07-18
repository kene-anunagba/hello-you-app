//
//  MatchingView.swift
//  hello you
//
//  Screen 04 "Matching" from the Hello, you. design: not a spinner but a
//  slow breathing pulse, so the wait itself feels calm and intentional.
//

import SwiftUI

struct MatchingView: View {
    @Environment(\.dismiss) private var dismiss

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

                ZStack {
                    ForEach(0..<3) { i in
                        PulseRing(delay: Double(i))
                    }
                    PulseCore()
                }
                .frame(width: 96, height: 96)

                VStack(spacing: 8) {
                    Text("Finding your person")
                        .font(.system(size: 22, weight: .semibold))
                        .tracking(-0.66)
                        .foregroundColor(HYColor.text)

                    Text("Someone who likes to listen")
                        .font(.system(size: 14))
                        .foregroundColor(HYColor.dim)

                    HStack(spacing: 6) {
                        ForEach(0..<3) { i in
                            BlinkDot(delay: Double(i) * 0.2)
                        }
                    }
                    .padding(.top, 14)
                }
                .padding(.top, 56)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(-0.16)
                        .foregroundColor(HYColor.text)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(HYColor.surface2, in: RoundedRectangle(cornerRadius: 27))
                        .overlay(
                            RoundedRectangle(cornerRadius: 27)
                                .stroke(HYColor.hair, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 26)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

/// The still lavender core at the centre of the matching stage.
private struct PulseCore: View {
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color(hex: 0xCABFF4), Color(hex: 0x8F84C4), Color(hex: 0x4B4470)],
                    center: UnitPoint(x: 0.35, y: 0.3),
                    startRadius: 0,
                    endRadius: 60
                )
            )
            .frame(width: 96, height: 96)
            .overlay(
                Circle()
                    .fill(Color.white)
                    .frame(width: 15, height: 15)
            )
    }
}

/// One of the three rings that slowly expand and fade outward from the core, staggered a second apart.
/// With Reduce Motion on, the three rings sit still at staggered sizes instead of animating.
private struct PulseRing: View {
    var delay: Double

    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var staticScale: CGFloat { 1 + delay * 0.6 }

    var body: some View {
        Circle()
            .stroke(HYColor.lav.opacity(0.5), lineWidth: 1)
            .frame(width: 96, height: 96)
            .scaleEffect(reduceMotion ? staticScale : (animate ? 3 : 1))
            .opacity(reduceMotion ? 0.4 : (animate ? 0 : 0.7))
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(
                    Animation.easeOut(duration: 3).repeatForever(autoreverses: false).delay(delay)
                ) {
                    animate = true
                }
            }
    }
}

/// One of the three dots beneath the matching text, blinking in a staggered sequence.
private struct BlinkDot: View {
    var delay: Double

    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Circle()
            .fill(HYColor.faint)
            .frame(width: 6, height: 6)
            .opacity(reduceMotion ? 0.65 : (animate ? 1 : 0.3))
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(
                    Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true).delay(delay)
                ) {
                    animate = true
                }
            }
    }
}

#Preview {
    NavigationStack {
        MatchingView()
    }
}
