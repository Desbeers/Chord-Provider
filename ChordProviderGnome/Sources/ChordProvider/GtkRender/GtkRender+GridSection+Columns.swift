//
//  GtkRender+GridSection+Columns.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderMIDI

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
        /// Bool if the grid has playabale chords
        var haveChords: Bool {
            !(columns
                .flatMap(\.cells)
                .flatMap(\.parts)
                .map(\.content)
                .compactMap(\.getChord)
                .filter { $0.definition.knownChord }
            ).isEmpty
        }
        /// The body of the `View`
        var view: Body {
            VStack {
                if haveChords {
                    Toggle(
                        icon: .default(icon: playGridChords ? .mediaPlaybackStop : .mediaPlaybackStart),
                        isOn: $playGridChords
                    ) {
                        if playGridChords {
                            startGridPlayer()
                            /// Monitor the grid player
                            monitorGridPlayer()
                        } else {
                            Task {
                                await ChordProviderMIDI.shared.stopGrid()
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
                    if playGridChords && appState.scene.midiID != gridID {
                        /// Another grid is started; uncheck the toggle button
                        playGridChords = false
                    }
                    if playGridChords, columns.flatMap(\.cells) != ChordProviderMIDI.shared.snapshot.grids {
                        /// The grid has changed; stop the player
                        playGridChords = false
                        Task {
                            await ChordProviderMIDI.shared.stopGrid()
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
                switch part.content {
                case let .chord(definition, _, _):
                    if definition.isSilent {
                        Text(" . ")
                            .style(.dimmed)
                    } else {
                        GtkRender.SingleChord(part: part, coreSettings: coreSettings)
                            .halign(.center)
                            .style(part.dimmed ? .dimmed : .none)
                            .id(definition)
                    }

                case let .anyChord(textPart, _, _),
                    let .textChord(textPart),
                    let .text(textPart),
                    let .margin(textPart):
                    Text(textPart.display)
                        .useMarkup()
                case let .strum(symbol):
                    Widgets.BundleImage(strum: symbol)
                        .pixelSize(Int(14 * appState.settings.theme.zoom))
                        .style(.svgIcon)
                        .halign(.center)
                case let .barLine(symbol):
                    Text(symbol.display)
                        .style(.sectionGrid)
                        .halign(.center)
                case let .strumPattern(symbol):
                    Text(symbol.display)
                        .style(.sectionGrid)
                        .halign(.center)
                case let .repeating(symbol):
                    Text(symbol.rawValue)
                        .style(.sectionGrid)
                        .halign(.center)
                case .lyric:
                    /// A grid has no lyrics, comment or textblock
                    Views.Empty()
                }
            }
            .style(part.id == currentPartID && playGridChords ? .chordHighlight : .none)
            .halign(.center)
            .valign(.center)
            .padding(2, .horizontal)
            .id(part.description + playGridChords.description + currentPartID.description)
        }

        /// Monitor the grid player for its current chord
        /// - Note: This will cancel itself when the player is stopped
        private func monitorGridPlayer() {
            Idle(delay: .seconds(0.015)) {
                let chord = ChordProviderMIDI.shared.snapshot.currentMidiID
                if chord != currentPartID {
                    currentPartID = chord
                }
                return playGridChords
            }
        }

        /// Start the grid player
        private func startGridPlayer() {
            /// Set this grid as current
            appState.scene.midiID = gridID
            /// Capture the grids
            let grids = columns.flatMap(\.cells)
            Task {
                await ChordProviderMIDI.shared.setGridChords(grids)
                await ChordProviderMIDI.shared.playGrid()
            }
        }
    }
}
