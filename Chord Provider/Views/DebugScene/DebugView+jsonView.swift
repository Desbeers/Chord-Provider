//
//  DebugView+jsonView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension DebugView {

    /// The json tab of the `View`
    @ViewBuilder var jsonView: some View {
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
                            let metadata = try? JSONUtils.encode(song.metadata)
                            JSONPart(label: "Metadata of the Song", content: metadata)
                        case .sections:
                            ForEach(song.sections) { section in
                                let content = try? JSONUtils.encode(section)
                                JSONPart(label: "Section \(section.environment.rawValue)", content: content)
    #if DEBUG
                                Button("Decode") {
                                    let decoded = try? JSONUtils.decode(content ?? "error", struct: Song.Section.self)
                                    dump(decoded)
                                }
    #endif
                            }
                        case .chords:
                            let chords = try? JSONUtils.encode(song.chords)
                            JSONPart(label: "Chords", content: chords)
                        case .settings:
                            let settings = try? JSONUtils.encode(appState.settings)
                            JSONPart(label: "Application Settings", content: settings)
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
    struct JSONPart: View {
        let label: String
        let content: String?
        @State private var isExpanded: Bool = true
        /// The observable state of the application
        @Environment(AppStateModel.self) var appState
        var body: some View {
            Section(isExpanded: $isExpanded) {
                Text(JSONUtils.highlight(code: content ?? "error", editorSettings: appState.settings.editor))
                    .monospaced()
                    .padding(.bottom)
            } header: {
                HStack {
                    Button {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .rotationEffect(
                                !isExpanded ? Angle(degrees: 0) : Angle(degrees: 90)
                            )
                    }
                    .buttonStyle(.plain)
                    Text(label)
                        .font(.title)
                }
            }
            .animation(.default, value: isExpanded)
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
