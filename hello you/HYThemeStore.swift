//
//  HYThemeStore.swift
//  hello you
//
//  Drives the app's Cream/Dark appearance, matching the two themes defined
//  in the Hello, you. design (`:root` and `html[data-theme="light"]`).
//

import Combine
import SwiftUI

/// One full set of themed colour tokens.
struct HYPalette {
    let ink: Color
    let ink2: Color
    let surface: Color
    let surface2: Color
    let surface3: Color
    let hair: Color
    let hairStrong: Color
    let text: Color
    let dim: Color
    let faint: Color
    let ghost: Color
    let lav: Color
    let lavDeep: Color
    let lavSoft: Color
    let onPrimary: Color
    let warmTop: Color

    static let dark = HYPalette(
        ink: Color(hex: 0x0A0A0C),
        ink2: Color(hex: 0x0E0E11),
        surface: Color(hex: 0x161619),
        surface2: Color(hex: 0x1E1E23),
        surface3: Color(hex: 0x26262C),
        hair: Color.white.opacity(0.075),
        hairStrong: Color.white.opacity(0.14),
        text: Color(hex: 0xF2F0EC),
        dim: Color(hex: 0xF2F0EC, opacity: 0.54),
        faint: Color(hex: 0xF2F0EC, opacity: 0.30),
        ghost: Color(hex: 0xF2F0EC, opacity: 0.14),
        lav: Color(hex: 0xB7ACE4),
        lavDeep: Color(hex: 0x8F84C4),
        lavSoft: Color(hex: 0xB7ACE4, opacity: 0.16),
        onPrimary: Color(hex: 0x0A0A0C),
        warmTop: Color(hex: 0x141319)
    )

    static let light = HYPalette(
        ink: Color(hex: 0xF1EBDF),
        ink2: Color(hex: 0xEAE2D2),
        surface: Color(hex: 0xFBF7EF),
        surface2: Color(hex: 0xF3ECDE),
        surface3: Color(hex: 0xEAE1D0),
        hair: Color(hex: 0x2D261E, opacity: 0.09),
        hairStrong: Color(hex: 0x2D261E, opacity: 0.17),
        text: Color(hex: 0x2B2621),
        dim: Color(hex: 0x2B2621, opacity: 0.58),
        faint: Color(hex: 0x2B2621, opacity: 0.36),
        ghost: Color(hex: 0x2B2621, opacity: 0.13),
        lav: Color(hex: 0x6D60AE),
        lavDeep: Color(hex: 0x574B92),
        lavSoft: Color(hex: 0x8174C4, opacity: 0.12),
        onPrimary: Color(hex: 0xF7F2E8),
        warmTop: Color(hex: 0xF8F1E4)
    )
}

/// The single source of truth for which theme is active. Every screen holds an
/// `@ObservedObject` reference to `HYThemeStore.shared` so toggling `isDark`
/// (e.g. from the Settings segmented control) re-renders the whole app live.
final class HYThemeStore: ObservableObject {
    static let shared = HYThemeStore()

    private static let storageKey = "hy.isDark"

    @Published var isDark: Bool {
        didSet { UserDefaults.standard.set(isDark, forKey: Self.storageKey) }
    }

    private init() {
        if let stored = UserDefaults.standard.object(forKey: Self.storageKey) as? Bool {
            isDark = stored
        } else {
            isDark = true
        }
    }

    var palette: HYPalette { isDark ? .dark : .light }
}
