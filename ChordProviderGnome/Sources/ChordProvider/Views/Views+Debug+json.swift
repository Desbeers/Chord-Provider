//
//  Views+Debug+json.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Adwaita
import ChordProviderCore

extension Views.Debug {

    // MARK: JSON View

    /// The `Body` for the json view
    @ViewBuilder var json: Body {
        NavigationSplitView {
            List(JSONPage.allCases, selection: $appState.scene.selectedDebugJSONSection) { element in
                Text(element.description)
                    .halign(.start)
                    .padding()
            }
        } content: {
            ScrollView {
                VStack {
                    switch appState.scene.selectedDebugJSONSection {
                    case .metadata:
                        let metadata = try? JSONUtils.encode(appState.editor.song.metadata)
                        sourceView(metadata)
                    case .sections:
                        ForEach(appState.editor.song.sections) { section in
                            let content = try? JSONUtils.encode(section)
                            sectionPart(
                                row: ExpanderRow().title("Section <b>\(section.environment.rawValue)</b>").rows {
                                    sourceView(content)
                                }
                            )
                        }
                    case .chords:
                        ForEach(appState.editor.song.chords) { chord in
                            let content = try? JSONUtils.encode(chord)
                            sectionPart(
                                row: ExpanderRow().title("Chord <b>\(chord.display)</b>").rows {
                                    HStack {
                                        Views.ChordDiagram(chord: chord, settings: appState.editor.song.settings)
                                            .valign(.start)
                                        sourceView(content)
                                            .hexpand()
                                    }
                                }
                            )
                        }
                    case .settings:
                        let metadata = try? JSONUtils.encode(appState.editor.song.settings)
                        sourceView(metadata)
                    }
                }
                .padding()
            }
        }
        .vexpand()
    }

    /// Show a row in its own section
    /// - Parameter row: The `row`
    /// - Returns: An `AnyView` with the `row`
    private func sectionPart(row: AnyView) -> AnyView {
        Form {
            row
        }
        .padding()
    }
}
