//
//  AboutView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 29/09/2024.
//

import SwiftUI

/// SwiftUI `View` for the About Window
struct AboutView: View {
    /// The body of the `View`
    var body: some View {
        VStack {
            HStack {
                VStack {
                    // swiftlint:disable:next force_unwrapping
                    Image(nsImage: NSImage(named: "AppIcon")!)
                        .resizable()
                        .frame(width: 140, height: 140)
                }
                Divider()
                VStack(spacing: 10) {
                    Text("A beautiful and **real** macOS application to view and edit [ChordPro](https://www.chordpro.org) songs on your mac or export them to a PDF files.")
                    Text("The source code is released under the **GPL3 licence** and is available on [GitHub](https://github.com/Desbeers/Chord-Provider).")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical)
            Text("Version \(Bundle.main.releaseVersionNumber) \((Bundle.main.copyright))")
                .padding(.bottom)
                .font(.caption)
        }
        .frame(width: 380)
    }
}
