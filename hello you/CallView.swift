//
//  CallView.swift
//  hello you
//
//  Screen 06 "Voice call" and screen 07 "Continue?" from the Hello, you.
//  design: audio only, a breathing orb standing in for a face. At the
//  twenty-minute mark, a bottom sheet asks whether to keep talking —
//  consent is mutual and visible.
//

import Combine
import SwiftUI

private let callPartnerName = "Night Owl"
private let callDurationSeconds = 20 * 60
private let waveDelays: [Double] = [0, 0.2, 0.5, 0.1, 0.35, 0.6, 0.25, 0.45, 0.15]

struct CallView: View {
    @ObservedObject private var hyTheme = HYThemeStore.shared

    @State private var secondsRemaining = callDurationSeconds
    @State private var isMuted = false
    @State private var isSpeakerOn = false
    @State private var showContinueSheet = false
    @State private var didEndCall = false

    private var timeString: String {
        let m = max(secondsRemaining, 0) / 60
        let s = max(secondsRemaining, 0) % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        ZStack {
            HYColor.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("ENCRYPTED · ANONYMOUS")
                    .font(.system(size: 11, design: .monospaced))
                    .tracking(1.32)
                    .foregroundColor(HYColor.faint)
                    .padding(.top, 14)

                callStage
            }
            .opacity(showContinueSheet ? 0.35 : 1)
            .blur(radius: showContinueSheet ? 1 : 0)
            .animation(.easeOut(duration: 0.3), value: showContinueSheet)

            if showContinueSheet {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
            }

            VStack {
                Spacer()
                if showContinueSheet {
                    ContinueSheet(
                        partnerName: callPartnerName,
                        onContinue: {
                            withAnimation(.easeOut(duration: 0.3)) {
                                secondsRemaining = callDurationSeconds
                                showContinueSheet = false
                            }
                        },
                        onEnd: {
                            didEndCall = true
                        }
                    )
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $didEndCall) {
            EndOfCallView()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard secondsRemaining > 0, !showContinueSheet else { return }
            secondsRemaining -= 1
            if secondsRemaining == 0 {
                withAnimation(.easeOut(duration: 0.3)) {
                    showContinueSheet = true
                }
            }
        }
    }

    private var callStage: some View {
        VStack(spacing: 0) {
            Spacer()

            BreathingOrb()

            Text(callPartnerName)
                .font(.system(size: 26, weight: .semibold))
                .tracking(-0.78)
                .foregroundColor(HYColor.text)
                .padding(.top, 34)

            Text("\(timeString) left")
                .font(.system(size: 15, design: .monospaced))
                .tracking(0.6)
                .foregroundColor(HYColor.dim)
                .padding(.top, 8)

            HStack(spacing: 3) {
                ForEach(waveDelays.indices, id: \.self) { i in
                    WaveBar(delay: waveDelays[i])
                }
            }
            .frame(height: 30)
            .padding(.top, 26)

            #if DEBUG
            Button {
                withAnimation(.easeOut(duration: 0.3)) {
                    secondsRemaining = 0
                    showContinueSheet = true
                }
            } label: {
                Text("DEBUG · skip to 0:00")
                    .font(.system(size: 11))
                    .foregroundColor(HYColor.faint)
            }
            .padding(.top, 14)
            #endif

            Spacer()

            HStack(spacing: 26) {
                CallControlButton(
                    systemImage: isMuted ? "mic.slash.fill" : "mic.fill",
                    label: "Mute",
                    isActive: isMuted
                ) {
                    isMuted.toggle()
                }

                CallControlButton(
                    systemImage: "speaker.wave.2.fill",
                    label: "Speaker",
                    isActive: isSpeakerOn
                ) {
                    isSpeakerOn.toggle()
                }

                CallControlButton(
                    systemImage: "phone.down.fill",
                    label: "Leave",
                    isActive: false,
                    isLeave: true
                ) {
                    didEndCall = true
                }
            }
            .padding(.bottom, 22)
        }
    }
}

private struct BreathingOrb: View {
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color(hex: 0xCDC3F2), Color(hex: 0x8F84C4), Color(hex: 0x413B63)],
                    center: UnitPoint(x: 0.35, y: 0.3),
                    startRadius: 0,
                    endRadius: 95
                )
            )
            .frame(width: 150, height: 150)
            .shadow(color: HYColor.lavFill.opacity(animate ? 0.42 : 0.28), radius: animate ? 45 : 30)
            .scaleEffect(animate ? 1.04 : 1)
            .padding(.top, 40)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
    }
}

private struct WaveBar: View {
    var delay: Double

    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        RoundedRectangle(cornerRadius: 1.5)
            .fill(HYColor.lav.opacity(0.9))
            .frame(width: 3, height: reduceMotion ? 14 : (animate ? 26 : 8))
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(
                    Animation.easeInOut(duration: 0.55).repeatForever(autoreverses: true).delay(delay)
                ) {
                    animate = true
                }
            }
    }
}

private struct CallControlButton: View {
    var systemImage: String
    var label: String
    var isActive: Bool
    var isLeave: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(isLeave ? HYColor.red : (isActive ? HYColor.lavSoft : HYColor.surface2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle().stroke(isLeave ? Color.clear : HYColor.hair, lineWidth: 1)
                    )
                    .overlay(
                        Image(systemName: systemImage)
                            .font(.system(size: 20))
                            .foregroundColor(isLeave ? HYColor.onLeave : (isActive ? HYColor.lav : HYColor.text))
                    )

                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(isLeave ? HYColor.red : HYColor.dim)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct ContinueSheet: View {
    var partnerName: String
    var onContinue: () -> Void
    var onEnd: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(HYColor.ghost)
                .frame(width: 38, height: 4)
                .padding(.bottom, 20)

            VStack(spacing: 10) {
                Text("TWENTY MINUTES")
                    .font(.system(size: 11, design: .monospaced))
                    .tracking(1.32)
                    .foregroundColor(HYColor.faint)

                Text("That went quickly.")
                    .font(.system(size: 24, weight: .semibold))
                    .tracking(-0.72)
                    .foregroundColor(HYColor.text)
                    .padding(.top, 2)

                Text("Keep talking for another twenty?\nYou'll both need to agree.")
                    .font(.system(size: 14))
                    .foregroundColor(HYColor.dim)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            HStack(spacing: 8) {
                HYAvatar(kind: .a3, size: 26)
                Text("\(partnerName) said yes")
                    .font(.system(size: 13))
                    .foregroundColor(HYColor.dim)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(HYColor.green)
            }
            .padding(.vertical, 22)

            VStack(spacing: 11) {
                Button(action: onContinue) {
                    Text("Continue · 20 more minutes")
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(-0.16)
                        .foregroundColor(HYColor.onLavender)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(HYColor.lavFill, in: RoundedRectangle(cornerRadius: 27))
                }
                .buttonStyle(.plain)

                Button(action: onEnd) {
                    Text("End here, on a good note")
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(-0.16)
                        .foregroundColor(HYColor.text)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(HYColor.surface2, in: RoundedRectangle(cornerRadius: 27))
                        .overlay(RoundedRectangle(cornerRadius: 27).stroke(HYColor.hair, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 26)
        .padding(.top, 26)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
        .background(HYColor.surface, in: RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
        .overlay(
            RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                .stroke(HYColor.hairStrong, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.5), radius: 40, y: -20)
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    NavigationStack {
        CallView()
    }
}
