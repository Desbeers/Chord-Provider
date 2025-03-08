//
//  WelcomeView+templates.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
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
                        Label(
                            title: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Molly Malone")
                                            .foregroundStyle(.primary)
                                            Text("Only rendered properly with the ChordPro CLI")
                                                .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            },
                            icon: {
                                Image(systemName: "document.badge.gearshape")
                                    .foregroundStyle(Color.accent)
                            }
                        )
                    }
                } header: {
                    Text("Official **ChordPro** examples")
                }
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
