//
//  OnboardingView.swift
//  hello you
//
//  Screen 01 "Onboarding" from the Hello, you. design: the greeting stated
//  plainly before anything is asked of you.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject private var hyTheme = HYThemeStore.shared
    #if DEBUG
    @State private var showDevMenu = false
    #endif

    @State private var isSigningIn = false
    @State private var signInError: String?
    @State private var pendingNewUserID: UUID?
    @State private var goToMoodSelection = false

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

            #if DEBUG
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showDevMenu = true
                    } label: {
                        Text("DEV MENU")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(HYColor.faint)
                            .padding(8)
                    }
                }
                Spacer()
            }
            .padding(.top, 8)
            .padding(.trailing, 12)
            #endif

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 0) {
                    HYMark(size: 56)
                        .padding(.bottom, 30)

                    (
                        Text("Hello").foregroundColor(HYColor.text)
                        + Text(",").foregroundColor(HYColor.lav)
                        + Text(" you.").foregroundColor(HYColor.text)
                    )
                    .font(.system(size: 38, weight: .semibold))
                    .tracking(-1.9)
                    .multilineTextAlignment(.center)

                    Text("A quiet place to talk with one real person, when you'd rather not be alone.")
                        .font(.system(size: 16))
                        .foregroundColor(HYColor.dim)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.top, 18)
                }

                Spacer()

                VStack(spacing: 11) {
                    Button {
                        handleSignIn()
                    } label: {
                        Text("Choose your name")
                            .font(.system(size: 16, weight: .semibold))
                            .tracking(-0.16)
                            .foregroundColor(HYColor.onPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(HYColor.text, in: RoundedRectangle(cornerRadius: 27))
                    }
                    .buttonStyle(.plain)
                    .disabled(isSigningIn)

                    Button {
                        handleSignIn()
                    } label: {
                        Text("I already have an account")
                            .font(.system(size: 16, weight: .semibold))
                            .tracking(-0.16)
                            .foregroundColor(HYColor.text)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .overlay(
                                RoundedRectangle(cornerRadius: 27)
                                    .stroke(HYColor.hairStrong, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(isSigningIn)

                    Text("No phone number. No socials. No last name.")
                        .font(.system(size: 11.5))
                        .foregroundColor(HYColor.faint)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.top, 6)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 30)

            if isSigningIn {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .tint(HYColor.lav)
                    .scaleEffect(1.3)
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $goToMoodSelection) {
            MoodSelectionView()
        }
        .navigationDestination(item: $pendingNewUserID) { userID in
            NameEntryView(userID: userID)
        }
        .alert(
            "Sign-in failed",
            isPresented: Binding(
                get: { signInError != nil },
                set: { if !$0 { signInError = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(signInError ?? "")
        }
        #if DEBUG
        .sheet(isPresented: $showDevMenu) {
            DevMenuView()
        }
        #endif
    }

    private func handleSignIn() {
        guard !isSigningIn else { return }
        isSigningIn = true
        signInError = nil
        Task {
            do {
                let (userID, profile) = try await AppleSignInManager.shared.signIn()
                isSigningIn = false
                if profile != nil {
                    goToMoodSelection = true
                } else {
                    pendingNewUserID = userID
                }
            } catch {
                isSigningIn = false
                signInError = error.localizedDescription
            }
        }
    }
}

#Preview {
    OnboardingView()
}
