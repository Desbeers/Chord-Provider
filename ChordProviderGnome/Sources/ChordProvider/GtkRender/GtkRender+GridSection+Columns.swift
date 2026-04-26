//
//  GtkRender+GridSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender.GridSection {

    /// The `View` for columns of a grid section
    struct Columns: View {
        /// Init the `View`
        /// - Parameters:
        ///   - columns: The Grid columns
        ///   - coreSettings: The core settings
        ///   - appState: The state of the application
        init(
            columns: [Song.Section.Line.Grid],
            coreSettings: ChordProviderSettings,
            appState: Binding<AppState>
        ) {
            self.columns = columns
            self.coreSettings = coreSettings
            self._appState = appState
        }
        /// The columns of the grid
        let columns: [Song.Section.Line.Grid]
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The state of the application
        @Binding var appState: AppState
        /// Bool to play the chords with MIDI
        @State private var playGridChords: Bool = false
        /// The ID of the grid
        @State private var gridID = UUID()
        /// The part that is currently playing with MIDI 
        @State private var currentPartID: Int = -1
        /// The body of the `View`
        var view: Body {
            VStack {
                if !(columns.flatMap(\.cells).flatMap(\.parts).filter { $0.chordDefinition?.knownChord ?? false }).isEmpty {
                    Toggle(icon: .default(icon: playGridChords ? .mediaPlaybackStop : .mediaPlaybackStart), isOn: $playGridChords) {
                        if playGridChords {
                            /// Set this grid as current
                            appState.scene.gridChordsID = gridID
                            /// Capture the grids
                            let grids = columns.flatMap(\.cells)
                            Task {
                                await Utils.MidiPlayer.shared.setGridChords(
                                    grids: grids
                                )
                                await Utils.MidiPlayer.shared.startChords()
                            }
                            /// Monitor the chords player
                            monitorChordsPlayer()
                        } else {
                            Idle {
                                currentPartID = -1
                            }
                            Task {
                                await Utils.MidiPlayer.shared.stopChords()
                            }
                        } 
                    }
                    .halign(.start)
                    .flat()
                }
                ForEach(columns, horizontal: true) { column in
                    Box {
                        ForEach(column.cells.flatMap(\.parts), horizontal: false) { item in
                            part(part: item)
                        }
                        .homogeneous()
                    }
                    .homogeneous()
                    }
            }
             .padding(10)
            .onUpdate {
                Idle {
                    if playGridChords && appState.scene.gridChordsID != gridID {
                        /// Another grid is started; uncheck the toggle button and reset current part
                        playGridChords = false
                        currentPartID = -1
                    }
                    if playGridChords, columns.flatMap(\.cells) != Utils.MidiPlayer.shared.getCurrentGrid {
                        /// The grid has changed; stop the player and reset current part
                        playGridChords = false
                        currentPartID = -1
                        Task {
                                await Utils.MidiPlayer.shared.stopChords()
                        }
                    }
                }
            }
        }

        /// Render a part of the grid
        /// - Parameter part: The part to render
        /// - Returns: A `View`
        private func part(part: Song.Section.Line.Part) -> AnyView {
            Box {
                // Text(part.strum?.beatItems.description ?? "-")
                //     .style(.error)
                if let chord = part.chordDefinition {
                    if chord.strum == .noStrum || chord.kind == .textChord {
                        Text(chord.kind == .textChord && chord.strum != .noStrum ? chord.plain : " . ")
                            .style(.dimmed)
                    } else {
                        GtkRender.SingleChord(part: part, coreSettings: coreSettings)
                            .halign(.center)
                            .style(part.hidden ? .dimmed : .none)
                            .id(chord.description + (chord.strum?.rawValue ?? ""))
                    }
                } else if let strum = part.strum?.strum, strum != .spacer {
                    Widgets.BundleImage(strum: strum)
                        .pixelSize(Int(14 * appState.settings.theme.zoom))
                        .style(.svgIcon)
                        .halign(.center)
                } else if let barLineSymbol = part.strum?.barLineSymbol {
                    Text(barLineSymbol.display)
                        .useMarkup()
                        .style(.sectionGrid)
                        .halign(.center)
                } else if let strumPattern = part.strum?.strumPattern {
                    Text(strumPattern.display)
                        .useMarkup()
                        .style(.sectionGrid)
                        .halign(.center)
                } else {
                    Text(part.text?.escapeSpecialCharacters() ?? "   ")
                        .useMarkup()
                        /// Just for visual reason...
                        .style(part.text == "&" ? .caption : .none)
                        .style(.standard)
                        .halign(.center)
                }
            }
            .style(part.id == currentPartID && playGridChords ? .chordHighlight : .none)
            .halign(.center)
            .valign(.center)
            .padding(2, .horizontal)
            .id(part.description + playGridChords.description + String(currentPartID))
        }

        /// Monitor the chords player for its current chord
        /// - Note: This will cancel itself when the player is stopped
        private func monitorChordsPlayer() {
            Idle(delay: .seconds(0.005)) {
                let chord = Utils.MidiPlayer.shared.currentChord
                if chord != currentPartID {
                    currentPartID = chord
                }
                return playGridChords
            }
        }
    }
}
