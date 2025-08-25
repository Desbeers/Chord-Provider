//
//  WelcomeView+templates.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension WelcomeView {

    /// The body of the `View`
    var templates: some View {
        VStack {
            List {
                Section {
                    Button {
                        if
                            let sampleSong = Bundle.main.url(forResource: Samples.help.rawValue, withExtension: "chordpro"),
                            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
                            newSong(text: content, template: sampleSong)
                        }
                    } label: {
                        Label("The Help document in ChordPro format", systemImage: "document.badge.gearshape")
                    }
                    .listRowSeparator(.hidden)

                    Button {
                        if
                            let sampleSong = Bundle.main.url(forResource: Samples.markdown.rawValue, withExtension: "chordpro"),
                            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
                            newSong(text: content, template: sampleSong)
                        }
                    } label: {
                        Label("Markdown formatting", systemImage: "document.badge.gearshape")
                    }
                    .listRowSeparator(.hidden)
                } header: {
                    Text("Help songs").font(.headline)
                }
                Section {
                    Button {
                        if
                            let sampleSong = Bundle.main.url(forResource: Samples.swingLowSweetChariot.rawValue, withExtension: "chordpro"),
                            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
                            newSong(text: content, template: sampleSong)
                        }
                    } label: {
                        Label("Swing Low Sweet Chariot", systemImage: "document.badge.gearshape")
                    }

                    Button {
                        if
                            let sampleSong = Bundle.main.url(forResource: Samples.mollyMalone.rawValue, withExtension: "chordpro"),
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
                    Text("Official **ChordPro** examples").font(.headline)
                }
                .listRowSeparator(.hidden)
#if DEBUG
                Section {
                    ForEach(Samples.debug, id: \.self) { debug in
                        Button {
                            if
                                let debug = Bundle.main.url(forResource: debug.rawValue, withExtension: "chordpro"),
                                let content = try? String(contentsOf: debug, encoding: .utf8) {
                                newSong(text: content, template: debug)
                            }
                        } label: {
                            Label(debug.rawValue, systemImage: "document.badge.gearshape")
                        }
                    }
                } header: {
                    Text("Debug").font(.headline)
                }
                .listRowSeparator(.hidden)
#endif
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
