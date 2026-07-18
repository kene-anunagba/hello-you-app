//
//  NameEntryView.swift
//  hello you
//
//  First screen after a successful Apple sign-in for a new user: choose
//  the name everyone else in the app will see. No last names, matching
//  the promise made on the onboarding screen.
//

import SwiftUI

struct NameEntryView: View {
    let userID: UUID

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var hyTheme = HYThemeStore.shared

    @State private var name = ""
    @FocusState private var isFocused: Bool

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

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
                navBar

                VStack(alignment: .leading, spacing: 0) {
                    Text("What should we\ncall you?")
                        .font(.system(size: 30, weight: .semibold))
                        .tracking(-1.05)
                        .foregroundColor(HYColor.text)
                        .lineSpacing(3)

                    Text("This is what people you talk to will see. No last names, no handles.")
                        .font(.system(size: 14.5))
                        .foregroundColor(HYColor.dim)
                        .lineSpacing(3)
                        .padding(.top, 12)

                    TextField("", text: $name, prompt: Text("Your name").foregroundColor(HYColor.faint))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(HYColor.text)
                        .tint(HYColor.lav)
                        .padding(.horizontal, 18)
                        .frame(height: 54)
                        .background(HYColor.surface, in: RoundedRectangle(cornerRadius: 18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(isFocused ? HYColor.lavSelBorder : HYColor.hair, lineWidth: 1)
                        )
                        .focused($isFocused)
                        .submitLabel(.continue)
                        .padding(.top, 28)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)
                .padding(.top, 12)

                Spacer()

                NavigationLink {
                    AvatarSelectionView(userID: userID, displayName: trimmedName)
                } label: {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(-0.16)
                        .foregroundColor(HYColor.onLavender)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(HYColor.lavFill, in: RoundedRectangle(cornerRadius: 27))
                        .opacity(trimmedName.isEmpty ? 0.5 : 1)
                }
                .buttonStyle(.plain)
                .disabled(trimmedName.isEmpty)
                .padding(.horizontal, 26)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear { isFocused = true }
    }

    private var navBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(HYColor.dim)
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 26)
        .padding(.top, 6)
        .padding(.bottom, 18)
    }
}

#Preview {
    NavigationStack {
        NameEntryView(userID: UUID())
    }
}
