//
//  WelcomeView+templates.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

extension WelcomeView {

    /// The body of the `View`
    var templates: some View {
        VStack {
            List {
                Section {
                    Button {
                        if
                            let sampleSong = Bundle.main.url(forResource: "Swing Low Sweet Chariot", withExtension: "chordpro"),
                            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
                            newSong(text: content, template: sampleSong)
                        }
                    } label: {
                        Label("Swing Low Sweet Chariot", systemImage: "document.badge.gearshape")
                    }

                    Button {
                        if
                            let sampleSong = Bundle.main.url(forResource: "Molly Malone", withExtension: "chordpro"),
                            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
                            newSong(text: content, template: sampleSong)
                        }
                    } label: {
                        Label("Molly Malone", systemImage: "document.badge.gearshape")
                    }
                } header: {
                    Text("Official **ChordPro** examples")
                } footer: {
                    Text("Only rendered properly with the ChordPro CLI")
                }
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
