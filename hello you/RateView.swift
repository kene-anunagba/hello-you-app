//
//  RateView.swift
//  hello you
//
//  Screen 09 "Rate conversation" from the Hello, you. design: private,
//  tag-based, about warmth and respect — a reputation that can't be gamed
//  by appearance.
//

import SwiftUI

private let allRateTags = ["Kind", "Great listener", "Funny", "Thoughtful", "Easy to talk to", "Respectful"]
private let defaultOnTags: Set<String> = ["Kind", "Great listener", "Easy to talk to"]

private let ratingCaptions = [
    1: "Not great",
    2: "It was okay",
    3: "Pretty good",
    4: "Really good company",
    5: "Wonderful",
]

struct RateView: View {
    @ObservedObject private var hyTheme = HYThemeStore.shared

    @State private var rating = 4
    @State private var onTags: Set<String> = defaultOnTags

    var body: some View {
        ZStack {
            HYColor.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 36)

                Text("How was it?")
                    .font(.system(size: 26, weight: .semibold))
                    .tracking(-0.78)
                    .foregroundColor(HYColor.text)

                Text("Only you see this. It shapes who you're paired with next.")
                    .font(.system(size: 14.5))
                    .foregroundColor(HYColor.dim)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .padding(.horizontal, 40)

                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { i in
                        Button {
                            withAnimation(.easeOut(duration: 0.15)) {
                                rating = i
                            }
                        } label: {
                            Image(systemName: i <= rating ? "star.fill" : "star")
                                .font(.system(size: 26))
                                .foregroundColor(i <= rating ? HYColor.lavFill : HYColor.ghost)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 30)
                .padding(.bottom, 8)

                Text(ratingCaptions[rating] ?? "")
                    .font(.system(size: 13))
                    .foregroundColor(HYColor.dim)

                FlowTags(tags: allRateTags, onTags: $onTags)
                    .padding(.top, 26)
                    .padding(.horizontal, 26)

                Spacer()

                NavigationLink {
                    TalkAgainView()
                } label: {
                    Text("Submit rating")
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(-0.16)
                        .foregroundColor(HYColor.onPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(HYColor.text, in: RoundedRectangle(cornerRadius: 27))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 26)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(hyTheme.isDark ? .dark : .light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

/// A centered, wrapping row of toggleable tag chips.
private struct FlowTags: View {
    let tags: [String]
    @Binding var onTags: Set<String>

    var body: some View {
        FlowLayout(spacing: 9) {
            ForEach(tags, id: \.self) { tag in
                let isOn = onTags.contains(tag)
                Button {
                    withAnimation(.easeOut(duration: 0.15)) {
                        if isOn { onTags.remove(tag) } else { onTags.insert(tag) }
                    }
                } label: {
                    Text(tag)
                        .font(.system(size: 13))
                        .foregroundColor(isOn ? HYColor.lav : HYColor.dim)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 9)
                        .background(isOn ? HYColor.lavSoft : HYColor.surface, in: Capsule())
                        .overlay(
                            Capsule().stroke(isOn ? HYColor.lavSelBorder : HYColor.hair, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// A simple wrapping flow layout for chip-style tags.
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var rowStart = 0
        var rowSubviews: [(LayoutSubview, CGSize)] = []

        func flushRow() {
            let totalWidth = rowSubviews.reduce(0) { $0 + $1.1.width } + CGFloat(max(0, rowSubviews.count - 1)) * spacing
            var rowX = bounds.minX + (maxWidth - totalWidth) / 2
            for (subview, size) in rowSubviews {
                subview.place(at: CGPoint(x: rowX, y: bounds.minY + y), anchor: .topLeading, proposal: ProposedViewSize(size))
                rowX += size.width + spacing
            }
            rowSubviews.removeAll()
        }

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                flushRow()
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
                rowStart += 1
            }
            rowSubviews.append((subview, size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        flushRow()
    }
}

#Preview {
    NavigationStack {
        RateView()
    }
}
