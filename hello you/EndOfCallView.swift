//
//  EndOfCallView.swift
//  hello you
//
//  Screen 08 "End of call" from the Hello, you. design: a gentle close.
//  What you shared is summarised, and what stayed private is named on
//  purpose.
//

import SwiftUI

private let recapRows: [(key: String, value: String)] = [
    ("Duration", "38 minutes"),
    ("Topic", "Books & late nights"),
    ("Kept private", "Everything"),
]

struct EndOfCallView: View {
    @ObservedObject private var hyTheme = HYThemeStore.shared

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
                Spacer()

                VStack(spacing: 0) {
                    HYAvatar(kind: .a3, size: 80)
                        .padding(.bottom, 24)

                    Text("That's a wrap.")
                        .font(.system(size: 27, weight: .semibold))
                        .tracking(-0.81)
                        .foregroundColor(HYColor.text)

                    Text("You spent some time with Night Owl.")
                        .font(.system(size: 15))
                        .foregroundColor(HYColor.dim)
                        .padding(.top, 10)

                    VStack(spacing: 0) {
                        ForEach(recapRows.indices, id: \.self) { i in
                            HStack {
                                Text(recapRows[i].key)
                                    .font(.system(size: 13))
                                    .foregroundColor(HYColor.dim)
                                Spacer()
                                Text(recapRows[i].value)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(HYColor.text)
                            }
                            .padding(.vertical, 11)
                            .overlay(alignment: .top) {
                                if i > 0 {
                                    Rectangle().fill(HYColor.hair).frame(height: 1)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background(HYColor.surface, in: RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(HYColor.hair, lineWidth: 1))
                    .padding(.top, 26)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

                Spacer()

                NavigationLink {
                    RateView()
                } label: {
                    Text("Rate the conversation")
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

#Preview {
    NavigationStack {
        EndOfCallView()
    }
}
