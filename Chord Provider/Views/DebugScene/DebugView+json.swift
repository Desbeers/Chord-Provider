//
//  DebugView+json.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 23/06/2025.
//

import SwiftUI

extension DebugView {

    /// The json tab of the `View`
    @ViewBuilder var json: some View {
        if appState.song != nil {
            List {
                if let song = appState.song {
                    ForEach(song.sections) { section in
                        let content = ChordProParser.encode(section)
                        jsonPart(label: "Section \(section.environment.rawValue)", content: content)
#if DEBUG
                        Button("Decode") {
                            ChordProParser.decode(content)
                        }
#endif
                    }
                    let metadata = ChordProParser.encode(song.metadata)
                    jsonPart(label: "Metadata of the Song", content: metadata)
                    let chords = ChordProParser.encode(song.chords)
                    jsonPart(label: "Chords", content: chords)
                    let settings = ChordProParser.encode(song.settings)
                    jsonPart(label: "Application Settings", content: settings)
                }
            }
        } else {
            noSong
        }
        Divider()
        ExportJSONButton(song: appState.song)
            .frame(height: 50, alignment: .center)
    }

    /// Add the JSON in a section
    /// - Parameters:
    ///   - label: The label
    ///   - content: The content
    /// - Returns: A `View`
    func jsonPart(label: String, content: String) -> some View {
        Section {
            Text(content)
                .monospaced()
                .padding(.bottom)
        } header: {
            Text(label)
                .font(.title)
        }
    }
}
