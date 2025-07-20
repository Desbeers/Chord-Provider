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
        HStack {
            List(selection: $jsonPart) {
                ForEach(Part.allCases, id: \.self) { part in
                    Text(part.rawValue)
                        .tag(part)
                }
            }
            .frame(width: 200)
            .listStyle(.sidebar)
            if appState.song != nil {
                List {
                    if let song = appState.song {

                        switch jsonPart {
                        case .metadata:
                            let metadata = ChordProParser.encode(song.metadata)
                            jsonPart(label: "Metadata of the Song", content: metadata)
                        case .sections:
                            ForEach(song.sections) { section in
                                let content = ChordProParser.encode(section)
                                jsonPart(label: "Section \(section.environment.rawValue)", content: content)
    #if DEBUG
                                Button("Decode") {
                                    ChordProParser.decode(content)
                                }
    #endif
                            }
                        case .chords:
                            let chords = ChordProParser.encode(song.chords)
                            jsonPart(label: "Chords", content: chords)
                        case .settings:
                            let settings = ChordProParser.encode(song.settings)
                            jsonPart(label: "Application Settings", content: settings)
                        }
                    }
                }
            } else {
                noSong
            }
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

extension DebugView {

    enum Part: String, CaseIterable {
        case metadata = "Metadata"
        case sections = "Sections"
        case chords = "Chords"
        case settings = "Settings"
    }
}
