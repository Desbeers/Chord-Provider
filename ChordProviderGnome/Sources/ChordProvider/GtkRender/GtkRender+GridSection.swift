//
//  GtkRender+GridSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderMIDI

extension GtkRender {

    /// The `View` for a grid section
    struct GridSection: View {
        /// The current section of the song
        let section: Song.Section
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
            HStack {
                if let events = section.gridEvents {
                    Toggle(
                        icon: .default(icon: playGridChords ? .mediaPlaybackStop : .mediaPlaybackStart),
                        isOn: $playGridChords
                    )
                    .clicked {
                        if playGridChords {
                            startGridPlayer(events)
                            /// Monitor the grid player
                            monitorGridPlayer()
                        } else {
                            Task {
                                await ChordProviderMIDI.shared.setCurrentTempo(nil)
                                await ChordProviderMIDI.shared.stopGrid()
                            }
                        }
                    }
                    .flat()
                    .valign(.start)
                }
                Separator()
                    .padding(2, .leading)
                VStack {
                    Text("\(section.tempo ?? appState.editor.song.metadata.tempo ?? 128) bpm")
                        .style(.caption)
                        .padding()
                        .halign(.start)
                    ForEach(section.lines) { line in
                        switch line.type {
                        case .gridLineColumns:
                            if let columns: [Song.Section.Line.Grid] = line.gridColumns {
                                Columns(
                                    columns: columns,
                                    coreSettings: coreSettings,
                                    appState: $appState,
                                    tempo: section.tempo,
                                    playGridChords: $playGridChords,
                                    currentPartID: $currentPartID

                                )
                            } else {
                                Text("The grid is empty")
                            }
                        case .emptyLine:
                            Views.Empty()
                        case .comment:
                            CommentLabel(line: line, maxLenght: appState.editor.song.metadata.longestLineLenght)
                        default:
                            Views.Empty()
                        }
                    }
                }
            }
            .padding(10, [.top,.trailing, .bottom])
            .onUpdate {
                Idle {
                    if playGridChords && appState.scene.midiID != gridID {
                        /// Another grid is started; uncheck the toggle button
                        playGridChords = false
                    }
                    if playGridChords, let grid = section.gridEvents, grid != ChordProviderMIDI.shared.snapshot.grids {
                        /// The grid has changed; stop the player
                        playGridChords = false
                        Task {
                            await ChordProviderMIDI.shared.stopGrid()
                        }
                    }
                    if playGridChords, let tempo = section.tempo, ChordProviderMIDI.shared.snapshot.currentTempo != tempo {
                        Task {
                            await ChordProviderMIDI.shared.setCurrentTempo(tempo)
                        }
                    }
                }
            }
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
        private func startGridPlayer(_ columns: [Song.Section.Line.GridCell]) {
            /// Set this grid as current
            appState.scene.midiID = gridID
            let tempo = section.tempo ?? 128
            let columns = columns
            Task {
                await ChordProviderMIDI.shared.setCurrentTempo(tempo)
                await ChordProviderMIDI.shared.setGridChords(columns)
                await ChordProviderMIDI.shared.playGrid()
            }
        }
    }
}
