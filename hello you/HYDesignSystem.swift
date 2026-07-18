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

/// Colour tokens from the "Hello, you." design. Themed tokens read live from
/// `HYThemeStore.shared`, so any screen that also holds an `@ObservedObject`
/// reference to that store re-renders with the new values when it changes.
/// A few tokens (marked below) are constants in the source CSS — they never
/// change between Cream and Dark — most notably `--lav-fill`, the solid
/// lavender used for filled buttons, and the brand mark's own SVG gradient.
enum HYColor {
    private static var p: HYPalette { HYThemeStore.shared.palette }

    static var ink: Color { p.ink }
    static var ink2: Color { p.ink2 }
    static var warmTop: Color { p.warmTop }
    static var text: Color { p.text }
    static var dim: Color { p.dim }
    static var faint: Color { p.faint }
    static var ghost: Color { p.ghost }
    static var hair: Color { p.hair }
    static var hairStrong: Color { p.hairStrong }
    static var lav: Color { p.lav }
    static var lavDeep: Color { p.lavDeep }
    static var lavSoft: Color { p.lavSoft }
    static var onPrimary: Color { p.onPrimary }
    static var surface: Color { p.surface }
    static var surface2: Color { p.surface2 }
    static var surface3: Color { p.surface3 }

    // Constants: unchanged between Cream and Dark per the source CSS.
    static let lavFill = Color(hex: 0xB7ACE4)
    static let lavLight = Color(hex: 0xC9BFF2)
    static let lavSelBorder = Color(hex: 0x8B7ECC, opacity: 0.55)
    static let lavSelRing = Color(hex: 0x8B7ECC, opacity: 0.08)
    static let onLavender = Color(hex: 0x191233)
    static let green = Color(hex: 0x8FBF9F)
    static let red = Color(hex: 0xE0928A)
    static let onLeave = Color(hex: 0x2A1512)
}

/// A gradient-filled avatar circle standing in for a person, matching the design's `.av.a1`–`.a5` swatches.
struct HYAvatar: View {
    enum Kind: String, CaseIterable, Codable {
        case a1, a2, a3, a4, a5

        var colors: [Color] {
            switch self {
            case .a1: return [Color(hex: 0xC9BFF2), Color(hex: 0x6E63A8), Color(hex: 0x2A2340)]
            case .a2: return [Color(hex: 0xD8D2C6), Color(hex: 0x8C8579), Color(hex: 0x2E2B26)]
            case .a3: return [Color(hex: 0x9FB2D6), Color(hex: 0x3E4C74), Color(hex: 0x1B2138)]
            case .a4: return [Color(hex: 0xE4C7B8), Color(hex: 0x9E7663), Color(hex: 0x2E211B)]
            case .a5: return [Color(hex: 0xBFC9BF), Color(hex: 0x5F7563), Color(hex: 0x22271F)]
            }
        }

        var center: UnitPoint {
            switch self {
            case .a1: return UnitPoint(x: 0.25, y: 0.2)
            case .a2: return UnitPoint(x: 0.3, y: 0.25)
            case .a3: return UnitPoint(x: 0.7, y: 0.2)
            case .a4: return UnitPoint(x: 0.3, y: 0.75)
            case .a5: return UnitPoint(x: 0.5, y: 0.25)
            }
        }
    }

    var kind: Kind
    var size: CGFloat = 64
    var borderColor: Color? = nil

    var body: some View {
        Circle()
            .fill(
                RadialGradient(colors: kind.colors, center: kind.center, startRadius: 0, endRadius: size * 0.9)
            )
            .frame(width: size, height: size)
            .overlay(
                Circle().stroke(borderColor ?? Color.white.opacity(0.10), lineWidth: borderColor != nil ? 3 : 1)
            )
    }
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

    // The brand mark's SVG defs use fixed hex stops, not the themed CSS
    // variables, so the logo stays constant across Cream and Dark.
    private static let brandDeep = Color(hex: 0x8F84C4)

    private var scale: CGFloat { size / 80 }
    private var strokeGradient: LinearGradient {
        LinearGradient(colors: [HYColor.lavLight, Self.brandDeep], startPoint: .top, endPoint: .bottom)
    }

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [HYColor.lavFill.opacity(0.5), HYColor.lavFill.opacity(0)],
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
                .fill(HYColor.lavFill)
                .frame(width: 10.8 * scale, height: 10.8 * scale)
                .position(x: 40 * scale, y: 33 * scale)
        }
        .frame(width: size, height: size)
    }
}

/// A single settings/safety list row: a small icon tile, a title with an
/// optional subtitle, and flexible trailing content (chevron, toggle, badge).
struct HYRow<Trailing: View>: View {
    var systemImage: String
    var title: String
    var subtitle: String? = nil
    var iconColor: Color = HYColor.text
    var showTopBorder: Bool = true
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 9)
                .fill(HYColor.surface3)
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: systemImage)
                        .font(.system(size: 14))
                        .foregroundColor(iconColor)
                )

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .tracking(-0.15)
                    .foregroundColor(HYColor.text)
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(HYColor.dim)
                }
            }

            Spacer(minLength: 8)

            trailing()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
        .overlay(alignment: .top) {
            if showTopBorder {
                Rectangle().fill(HYColor.hair).frame(height: 1)
            }
        }
    }
}

/// The rounded, bordered card that groups a set of `HYRow`s together.
struct HYRowGroup<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .background(HYColor.surface, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(HYColor.hair, lineWidth: 1))
    }
}

/// A section label above a row group, matching the design's uppercase caption.
struct HYGroupLabel: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .regular))
            .tracking(0.96)
            .textCase(.uppercase)
            .foregroundColor(HYColor.faint)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// A chevron accessory for rows that navigate or expand.
struct HYChevron: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(HYColor.faint)
    }
}
