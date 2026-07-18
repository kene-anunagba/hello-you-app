//
//  AvatarSelectionView.swift
//  hello you
//
//  Last step of profile setup: pick one of the five gradient avatar
//  styles from the design system. A colour, not a photo — easy to
//  recognize, impossible to judge.
//

import SwiftUI

struct AvatarSelectionView: View {
    let userID: UUID
    let displayName: String

    @ObservedObject private var hyTheme = HYThemeStore.shared

    @State private var selectedKind: HYAvatar.Kind?
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var didFinishSetup = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

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
                Spacer().frame(height: 24)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Pick your avatar")
                        .font(.system(size: 30, weight: .semibold))
                        .tracking(-1.05)
                        .foregroundColor(HYColor.text)

                    Text("A colour, not a photo. Easy to recognize, impossible to judge.")
                        .font(.system(size: 14.5))
                        .foregroundColor(HYColor.dim)
                        .lineSpacing(3)
                        .padding(.top, 12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)

                LazyVGrid(columns: columns, spacing: 22) {
                    ForEach(HYAvatar.Kind.allCases, id: \.self) { kind in
                        AvatarOption(kind: kind, isSelected: selectedKind == kind)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    selectedKind = kind
                                }
                            }
                    }
                }
                .padding(.horizontal, 26)
                .padding(.top, 40)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 12.5))
                        .foregroundColor(HYColor.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                        .padding(.top, 16)
                }

                Spacer()

                Button {
                    save()
                } label: {
                    ZStack {
                        Text("Save profile")
                            .opacity(isSaving ? 0 : 1)
                        if isSaving {
                            ProgressView()
                                .tint(HYColor.onLavender)
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .tracking(-0.16)
                    .foregroundColor(HYColor.onLavender)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(HYColor.lavFill, in: RoundedRectangle(cornerRadius: 27))
                    .opacity(selectedKind == nil ? 0.5 : 1)
                }
                .buttonStyle(.plain)
                .disabled(selectedKind == nil || isSaving)
                .padding(.horizontal, 26)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $didFinishSetup) {
            MoodSelectionView()
        }
    }

    private func save() {
        guard let selectedKind else { return }
        isSaving = true
        errorMessage = nil
        Task {
            do {
                try await AppleSignInManager.shared.saveProfile(
                    id: userID,
                    displayName: displayName,
                    avatarStyle: selectedKind.rawValue
                )
                isSaving = false
                didFinishSetup = true
            } catch {
                isSaving = false
                errorMessage = "Couldn't save your profile: \(error.localizedDescription)"
            }
        }
    }
}

private struct AvatarOption: View {
    let kind: HYAvatar.Kind
    let isSelected: Bool

    private let size: CGFloat = 76

    var body: some View {
        ZStack {
            HYAvatar(kind: kind, size: size)

            Circle()
                .strokeBorder(isSelected ? HYColor.lavSelRing : Color.clear, lineWidth: 4)
                .frame(width: size + 12, height: size + 12)

            Circle()
                .stroke(isSelected ? HYColor.lavSelBorder : Color.clear, lineWidth: 2)
                .frame(width: size + 12, height: size + 12)

            if isSelected {
                Circle()
                    .fill(HYColor.lavFill)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(HYColor.onLavender)
                    )
                    .overlay(Circle().stroke(HYColor.ink, lineWidth: 2))
                    .offset(x: size / 2.6, y: size / 2.6)
            }
        }
        .frame(width: size + 12, height: size + 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        AvatarSelectionView(userID: UUID(), displayName: "Noah")
    }
}
