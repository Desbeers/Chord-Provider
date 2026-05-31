//
//  GtkRender+TabSection+Columns.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderMIDI

extension GtkRender.TabSection {

    /// The `View` for columns of a tab section
    struct Columns: View {
        /// The columns of the grid
        let columns: [Song.Section.Line.Tab]
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The state of the application
        @Binding var appState: AppState
        /// The optional tempo
        let tempo: Int?
        /// Bool to play the tab with MIDI
        @State private var playTabNotes: Bool = false
        /// The ID of the grid
        @State private var tabID = UUID()
        /// The part that is currently playing with MIDI 
        @State private var currentPartID: Int = -1
        /// Bool if the tab has playabale notes
        var haveNotes: Bool {
            columns
                .flatMap(\.events)
                .contains { $0.content.hasPlayableItem }
        }
        /// The body of the `View`
        var view: Body {
            VStack {
                if haveNotes {
                    HStack {
                        Toggle(
                            icon: .default(icon: playTabNotes ? .mediaPlaybackStop : .mediaPlaybackStart),
                            isOn: $playTabNotes
                        )
                        .clicked {
                            if playTabNotes {
                                startTabPlayer()
                                /// Monitor the tab player
                                monitorTabPlayer()
                            } else {
                                Task {
                                    await ChordProviderMIDI.shared.setCurrentTempo(nil)
                                    await ChordProviderMIDI.shared.stopTab()
                                }
                            }
                        }
                        .flat()
                        Text("\(tempo ?? appState.editor.song.metadata.tempo ?? 128) bpm")
                            .style(.caption)
                            .padding(2, .leading)
                    }
                    .halign(.start)
                }
                ForEach(columns, horizontal: true) { column in
                    Box {
                        ForEach(column.events, horizontal: false) { item in
                            event(
                                event: item,
                                column: column.columnID
                            )
                        }
                        .homogeneous()
                    }
                    .homogeneous()
                }
            }
            .padding(10)
            .onUpdate {
                Idle {
                    if playTabNotes && appState.scene.midiID != tabID {
                        /// Another grid or tab is started; uncheck the toggle button
                        playTabNotes = false
                    }
                    if playTabNotes, columns != ChordProviderMIDI.shared.snapshot.tabs {
                        /// The tab has changed; stop the player
                        playTabNotes = false
                        Task {
                            await ChordProviderMIDI.shared.stopTab()
                        }
                    }
                    if playTabNotes, let tempo, ChordProviderMIDI.shared.snapshot.currentTempo != tempo {
                        Task {
                            await ChordProviderMIDI.shared.setCurrentTempo(tempo)
                        }
                    }
                }
            }
        }

        private func event(event: Song.Section.Line.Tab.Event, column: Int) -> AnyView {
            Box {
                switch event.content {
                case .rest(let display):
                    Text(display)
                        .style(.dimmed)
                case .text(let text):
                    Text(text)
                        .halign(.start)
                case .barLine:
                    Text("|")
                case let .fret(display, _, filler):
                    HStack {
                        Text(display)
                            .style(column == currentPartID && playTabNotes ? .chordHighlight : .none)
                            .id(playTabNotes.description + currentPartID.description)
                        Text(filler)
                    }
                    .style(.tabButton)
                case let .transition(display, _, _, _):
                    Text(display)
                        .style(.tabButton)
                        .style(column == currentPartID && playTabNotes ? .chordHighlight : .none)
                        .id(playTabNotes.description + currentPartID.description)
                }
            }
            .style(.sectionTab)
            .halign(.center)
        }
        
        /// Monitor the tab player for its current tab
        /// - Note: This will cancel itself when the player is stopped
        private func monitorTabPlayer() {
            Idle(delay: .seconds(0.015)) {
                let chordID = ChordProviderMIDI.shared.snapshot.currentMidiID
                if chordID != currentPartID {
                    currentPartID = chordID
                }
                return playTabNotes
            }
        }

        /// Start the tab player
        private func startTabPlayer() {
            /// Set this tab as current
            appState.scene.midiID = tabID
            // /// Capture stuff
            let columns = columns
            let tempo = tempo
            Task {
                await ChordProviderMIDI.shared.setCurrentTempo(tempo)
                await ChordProviderMIDI.shared.setTabNotes(columns)
                await ChordProviderMIDI.shared.startTab()
            }
        }
    }
}
