//
//  MoodSelectionView.swift
//  hello you
//
//  Screen 02 "Mood selection" from the Hello, you. design: for the highs as
//  much as the lows — Happy and Celebrating sit right at the top, next to Lonely.
//

import SwiftUI

struct MoodOption: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
}

private let moodOptions: [MoodOption] = [
    MoodOption(title: "Happy", subtitle: "In a good place right now", systemImage: "face.smiling"),
    MoodOption(title: "Celebrating", subtitle: "Good news I want to share", systemImage: "sparkles"),
    MoodOption(title: "Lonely", subtitle: "Could use some company", systemImage: "person"),
    MoodOption(title: "Stressed", subtitle: "Need to decompress", systemImage: "water.waves"),
    MoodOption(title: "Can't sleep", subtitle: "Awake and restless", systemImage: "moon"),
]

struct MoodSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var hyTheme = HYThemeStore.shared
    @State private var selectedMoodID: UUID? = moodOptions.first?.id

    var body: some View {
        ZStack {
            HYColor.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                VStack(alignment: .leading, spacing: 0) {
                    Text("Right now")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(2.16)
                        .textCase(.uppercase)
                        .foregroundColor(HYColor.lav)

                    Text("How are you\nfeeling?")
                        .font(.system(size: 30, weight: .semibold))
                        .tracking(-1.05)
                        .foregroundColor(HYColor.text)
                        .lineSpacing(3)
                        .padding(.top, 14)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)
                .padding(.top, 6)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 11) {
                        ForEach(moodOptions) { mood in
                            MoodOptionRow(mood: mood, isSelected: selectedMoodID == mood.id)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.16)) {
                                        selectedMoodID = mood.id
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 26)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                }

                NavigationLink {
                    NeedSelectionView()
                } label: {
                    Text("Next")
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(-0.16)
                        .foregroundColor(HYColor.onPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(HYColor.text, in: RoundedRectangle(cornerRadius: 27))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 26)
                .padding(.bottom, 22)
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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

            Spacer()

            Text("STEP 1 / 2")
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(HYColor.faint)

            Spacer()

            Color.clear.frame(width: 34, height: 34)
        }
        .padding(.horizontal, 26)
        .padding(.top, 6)
        .padding(.bottom, 18)
    }
}

private struct MoodOptionRow: View {
    let mood: MoodOption
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? HYColor.lavSoft : HYColor.surface2)
                Image(systemName: mood.systemImage)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(isSelected ? HYColor.lav : HYColor.text)
            }
            .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 1) {
                Text(mood.title)
                    .font(.system(size: 16, weight: .medium))
                    .tracking(-0.16)
                    .foregroundColor(HYColor.text)
                Text(mood.subtitle)
                    .font(.system(size: 12.5))
                    .foregroundColor(HYColor.dim)
            }

            Spacer(minLength: 8)

            Image(systemName: "checkmark")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(HYColor.lav)
                .opacity(isSelected ? 1 : 0)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(isSelected ? HYColor.lavSoft : HYColor.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(isSelected ? HYColor.lavSelRing : Color.clear, lineWidth: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isSelected ? HYColor.lavSelBorder : HYColor.hair, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        MoodSelectionView()
    }
}
