//
//  HelpView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for help
struct HelpView: View {
    /// The body of the `View`
    var body: some View {
        ScrollView {
            VStack {
                // swiftlint:disable:next force_unwrapping
                Image(nsImage: NSImage(named: "AppIcon")!)
                    .resizable()
                    .frame(width: 40, height: 40)
                Text("Chord Provider")
                    .font(.title)
                section("ChordPro viewer and editor", content: chordpro)
                Divider()
                if let url = URL(string: "https://github.com/Desbeers/Chord-Provider") {
                    Link(destination: url) {
                        Text("Chord Provider on GitHub")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .frame(width: 300)
        .frame(height: 440, alignment: .top)
        .background(Color(nsColor: .textBackgroundColor))
    }

    /// Wrap a chapter in a section
    /// - Parameters:
    ///   - header: The header
    ///   - content: The content
    /// - Returns: A `Section view`
    func section(_ header: String, content: String) -> some View {
        Section(header: Text(header).font(.title3)) {
            Text(.init(content))
                .multilineTextAlignment(.center)
        }
        .padding(6)
    }

    /// Refer to the official **ChordPro** implementation
    let chordpro: String =
"""
**ChordPro** is an open standard text format and its has its own [official reference implementation](https://www.chordpro.org/chordpro/chordpro-directives/).

I contributed a lot to its [Open Source code](https://github.com/ChordPro/chordpro).

While I hope you like **Chord Provider**, as *guitar player* or *macOS programmer*, it is just a hobby project for my own needs.

Go [there](https://chordpro.org) for the full **Chordpro** experience.
"""
}
