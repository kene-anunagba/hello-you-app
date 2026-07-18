//
//  NeedSelectionView.swift
//  hello you
//
//  Screen 03 "Need selection" from the Hello, you. design: your need gets
//  paired with its complement — a listener for a talker, someone to
//  celebrate the good news.
//

import SwiftUI

struct NeedOption: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
}

private let needOptions: [NeedOption] = [
    NeedOption(title: "Someone to listen", subtitle: "Space to talk it out", systemImage: "ear"),
    NeedOption(title: "Someone to celebrate", subtitle: "Share the good stuff", systemImage: "party.popper"),
    NeedOption(title: "Deep conversation", subtitle: "Go beyond small talk", systemImage: "bubble.left.and.bubble.right"),
    NeedOption(title: "Quiet company", subtitle: "Presence, low talk", systemImage: "waveform.path.ecg"),
    NeedOption(title: "Someone funny", subtitle: "Lighten the mood", systemImage: "theatermasks"),
    NeedOption(title: "Random chat", subtitle: "Wherever it goes", systemImage: "bubble.left"),
]

struct NeedSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var hyTheme = HYThemeStore.shared
    @State private var selectedNeedID: UUID? = needOptions.first?.id

    private let columns = [GridItem(.flexible(), spacing: 11), GridItem(.flexible(), spacing: 11)]

    var body: some View {
        ZStack {
            HYColor.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                VStack(alignment: .leading, spacing: 0) {
                    Text("And you'd like")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(2.16)
                        .textCase(.uppercase)
                        .foregroundColor(HYColor.lav)

                    Text("What do you\nneed?")
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
                    LazyVGrid(columns: columns, spacing: 11) {
                        ForEach(needOptions) { need in
                            NeedChip(need: need, isSelected: selectedNeedID == need.id)
                                .contentShape(RoundedRectangle(cornerRadius: 18))
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.16)) {
                                        selectedNeedID = need.id
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 26)
                    .padding(.top, 24)
                }

                NavigationLink {
                    MatchingView()
                } label: {
                    Text("Find someone")
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(-0.16)
                        .foregroundColor(HYColor.onLavender)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(HYColor.lavFill, in: RoundedRectangle(cornerRadius: 27))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 26)
                .padding(.top, 18)
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

            Text("STEP 2 / 2")
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

private struct NeedChip: View {
    let need: NeedOption
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 3) {
                Text(need.title)
                    .font(.system(size: 15.5, weight: .medium))
                    .tracking(-0.16)
                    .foregroundColor(HYColor.text)
                Text(need.subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(HYColor.dim)
                    .lineLimit(2)
            }

            Spacer(minLength: 14)

            Image(systemName: need.systemImage)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(isSelected ? HYColor.lav : HYColor.dim)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .frame(minHeight: 96, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(isSelected ? HYColor.lavSoft : HYColor.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isSelected ? HYColor.lavSelBorder : HYColor.hair, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        NeedSelectionView()
    }
}
