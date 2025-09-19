//
//  AboutView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the About Window
struct AboutView: View {
    /// The body of the `View`
    var body: some View {
        VStack {
            VStack {
                ImageUtils.applicationIcon()
                    .resizable()
                    .frame(width: 140, height: 140)
                Text("Chord Provider")
                    .font(.title)
                    .bold()
                Text("Version \(Bundle.main.releaseVersionNumber)")
                    .font(.caption)
            }
            .padding(.bottom)
            VStack(spacing: 10) {
                Text("A beautiful and **real** macOS application to view and edit [ChordPro](https://www.chordpro.org) songs on your Mac or export them to PDF files.")
                Text("The source code is released under the **GPL3 licence** and is available on [GitHub](https://github.com/Desbeers/Chord-Provider).")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .padding(.bottom)
            Text("\((Bundle.main.copyright))")
                .padding(.bottom)
                .font(.caption)
        }
        .frame(width: 240)
    }
}
