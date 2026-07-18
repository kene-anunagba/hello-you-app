//
//  DevMenuView.swift
//  hello you
//
//  Temporary, debug-only entry point into screens that don't yet have a
//  real path from the main flow (Settings, Safety Center, Premium).
//  Remove once those screens are reachable from the app proper.
//

import SwiftUI

struct DevMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var hyTheme = HYThemeStore.shared

    var body: some View {
        NavigationStack {
            ZStack {
                HYColor.ink.ignoresSafeArea()

                VStack(spacing: 11) {
                    NavigationLink("Settings") { SettingsView() }
                        .devMenuButtonStyle()
                    NavigationLink("Safety Center") { SafetyCenterView() }
                        .devMenuButtonStyle()
                    NavigationLink("Premium") { PremiumView() }
                        .devMenuButtonStyle()
                }
                .padding(.horizontal, 26)
                .padding(.top, 20)

                VStack {
                    Spacer()
                    Text("DEBUG BUILD ONLY")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(HYColor.faint)
                        .padding(.bottom, 20)
                }
            }
            .navigationTitle("Dev Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
    }
}

private struct DevMenuButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(HYColor.text)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(HYColor.surface2, in: RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(HYColor.hair, lineWidth: 1))
    }
}

private extension View {
    func devMenuButtonStyle() -> some View {
        modifier(DevMenuButtonStyle())
    }
}

#Preview {
    DevMenuView()
}
