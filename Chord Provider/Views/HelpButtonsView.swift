//
//  HelpButtonsView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 22/06/2024.
//

import SwiftUI

struct HelpButtonsView: View {
    /// The document in the environment
    @FocusedValue(\.document) private var document: FileDocumentConfiguration<ChordProDocument>?
    /// The body of the `View`
    var body: some View {
        if let sampleSong = Bundle.main.url(forResource: "Swing Low Sweet Chariot", withExtension: "chordpro") {
            Button("Insert a Song Example") {
                if let document, let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
                    document.document.text = content
                }
            }
            .disabled(document == nil)
        }
        Divider()
        if let url = URL(string: "https://github.com/Desbeers/Chord-Provider") {
            Link(destination: url) {
                Text("Chord Provider on GitHub")
            }
        }
    }
}
