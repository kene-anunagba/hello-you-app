//
//  HYDesignSystem.swift
//  hello you
//

import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

/// Colour tokens from the "Hello, you." design (dark theme).
enum HYColor {
    static let ink = Color(hex: 0x0A0A0C)
    static let warmTop = Color(hex: 0x141319)
    static let text = Color(hex: 0xF2F0EC)
    static let dim = Color(hex: 0xF2F0EC, opacity: 0.54)
    static let faint = Color(hex: 0xF2F0EC, opacity: 0.30)
    static let hairStrong = Color.white.opacity(0.14)
    static let lav = Color(hex: 0xB7ACE4)
    static let lavLight = Color(hex: 0xC9BFF2)
    static let lavDeep = Color(hex: 0x8F84C4)
    static let onPrimary = Color(hex: 0x0A0A0C)

    static let surface = Color(hex: 0x161619)
    static let surface2 = Color(hex: 0x1E1E23)
    static let hair = Color.white.opacity(0.075)
    static let lavSoft = Color(hex: 0xB7ACE4, opacity: 0.16)
    static let lavSelBorder = Color(hex: 0x8B7ECC, opacity: 0.55)
    static let lavSelRing = Color(hex: 0x8B7ECC, opacity: 0.08)
    static let onLavender = Color(hex: 0x191233)
}

/// The tail of the speech-bubble mark: a single curve trailing down-left from the bubble.
private struct HYMarkTail: Shape {
    func path(in rect: CGRect) -> Path {
        let s = rect.width / 80
        var path = Path()
        path.move(to: CGPoint(x: 27 * s, y: 55 * s))
        path.addCurve(
            to: CGPoint(x: 13 * s, y: 72 * s),
            control1: CGPoint(x: 25 * s, y: 63 * s),
            control2: CGPoint(x: 20 * s, y: 69 * s)
        )
        return path
    }
}

/// The "Hello, you." speech-bubble mark: a soft greeting bubble with a single presence dot.
struct HYMark: View {
    var size: CGFloat = 56

    private var scale: CGFloat { size / 80 }
    private var strokeGradient: LinearGradient {
        LinearGradient(colors: [HYColor.lavLight, HYColor.lavDeep], startPoint: .top, endPoint: .bottom)
    }

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [HYColor.lav.opacity(0.5), HYColor.lav.opacity(0)],
                center: .center,
                startRadius: 0,
                endRadius: 27 * scale
            )
            .frame(width: 54 * scale, height: 54 * scale)
            .position(x: 40 * scale, y: 34 * scale)

            RoundedRectangle(cornerRadius: 18 * scale)
                .stroke(strokeGradient, lineWidth: 3.4 * scale)
                .frame(width: 60 * scale, height: 44 * scale)
                .position(x: 40 * scale, y: 33 * scale)

            HYMarkTail()
                .stroke(strokeGradient, style: StrokeStyle(lineWidth: 3.4 * scale, lineCap: .round))

            Circle()
                .fill(HYColor.lav)
                .frame(width: 10.8 * scale, height: 10.8 * scale)
                .position(x: 40 * scale, y: 33 * scale)
        }
        .frame(width: size, height: size)
    }
}
