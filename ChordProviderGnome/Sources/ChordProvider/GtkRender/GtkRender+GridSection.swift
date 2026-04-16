//
//  GtkRender+GridSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a grid section
    struct GridSection: View {
        /// Init the `View`
        /// - Parameters:
        ///   - section: The Grid section
        ///   - coreSettings: The core settings
        ///   - appState: The state of the application
        init(
            section: Song.Section,
            coreSettings: ChordProviderSettings,
            appState: Binding<AppState>
        ) {
            self.section = section
            self.coreSettings = coreSettings
            self._appState = appState
            self.originalSection = section
            self.gridID = section.id
        }
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The state of the application
        @Binding var appState: AppState
        /// The current section of the song
        let originalSection: Song.Section
        /// The current section of the song; wrapped in columns
        let section: Song.Section
        /// Bool to play the chords with MIDI
        @State private var playGridChords: Bool = false
        /// The ID of the grid
        let gridID: Int
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .gridLineColumns:
                        if let columns = line.gridColumns {
                            if !(columns.flatMap(\.parts).filter { $0.chordDefinition?.knownChord ?? false }).isEmpty {
                                Toggle(icon: .default(icon: playGridChords ? .mediaPlaybackStop : .mediaPlaybackStart), isOn: $playGridChords) {
                                    if playGridChords {
                                        /// Set this grid as current
                                        appState.scene.gridChordsID = gridID
                                        /// Capture stuff
                                        let grids = columns
                                        let preset = coreSettings.midiPreset
                                        Task {
                                            await Utils.MidiPlayer.shared.setGridChords(
                                                grids: grids,
                                                preset: preset
                                            )
                                            await Utils.MidiPlayer.shared.startChords()
                                        }
                                    } else {
                                        Task {
                                            await Utils.MidiPlayer.shared.stopChords()
                                        }
                                    } 
                                }
                                .halign(.start)
                                .flat()
                            }
                            //.insensitive(columns.flatMap(\.parts).filter { $0.chordDefinition?.knownChord ?? false }.isEmpty)
                            ForEach(columns, horizontal: true) { column in
                                Box {
                                    ForEach(column.parts, horizontal: false) { item in
                                        part(part: item)
                                    }
                                    .homogeneous()
                                } 
                                .homogeneous()
                                //.id(elements)
                            }
                            //.homogeneous()
                        } else {
                            Text("Grid is empty")
                        }
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(line: line, maxLenght: appState.editor.song.metadata.longestLineLenght)
                    default:
                        Views.Empty()
                    }
                }
            }
            .padding(10)
            .onUpdate {
                Idle {
                    if playGridChords && appState.scene.gridChordsID != gridID {
                        /// Another grid is started; uncheck the toggle button
                        playGridChords = false
                    }
                }
            }
        }

        /// Render a part of the grid
        /// - Parameter part: The part to render
        /// - Returns: A `View`
        func part(part: Song.Section.Line.Part) -> AnyView {
            Box {
                // Text(part.chordDefinition?.display ?? part.strum?.description ?? "?")
                //     .style(.error)
                if part.chordDefinition != nil && part.chordDefinition?.kind != .textChord {
                    SingleChord(part: part, coreSettings: coreSettings)
                        .halign(.center)
                        .insensitive(part.hidden)
                } else if let strum = part.strum, strum != .spacer {
                    Widgets.BundleImage(strum: strum)
                        .pixelSize(Int(14 * appState.settings.theme.zoom))
                        .style(.svgIcon)
                        .halign(.center)
                } else {
                    Text(part.text?.escapeSpecialCharacters() ?? " ")
                        .useMarkup()
                        .style(.sectionGrid)
                        //.padding(5, .leading)
                        .halign(.center)
                }
            }
            //.hexpand()
            .halign(.center)
            .valign(.center)
            .padding(2, .horizontal)
            //.padding( 20 / (part.cells ?? 1), .trailing)
            .id(part)
        }
    }
}
