//
//  GtkRender+TabSection.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderMIDI

extension GtkRender {

    /// The `View` for a tab section
    struct TabSection: View {
        /// The current section of the song
        let section: Song.Section
        /// The state of the application
        @Binding var appState: AppState
        /// Bool to play the tab with MIDI
        @State private var playTabNotes: Bool = false
        /// The ID of the grid
        @State private var tabID = UUID()
        /// The part that is currently playing with MIDI 
        @State private var currentPartID: Int = -1
        /// The body of the `View`
        var view: Body {
            HStack {
                if let events = section.tabEvents {
                    Toggle(
                        icon: .default(icon: playTabNotes ? .mediaPlaybackStop : .mediaPlaybackStart),
                        isOn: $playTabNotes
                    )
                    .clicked {
                        if playTabNotes {
                            startTabPlayer(events)
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
                    .valign(.start)
                }
                Separator()
                    .padding(2, .leading)
                VStack {
                    Text("\(section.tempo ?? appState.editor.song.metadata.tempo ?? 128) bpm")
                        .style(.caption)
                        .zoom(appState.settings.theme.zoom)
                        .padding()
                        .halign(.start)
                    ForEach(section.lines) { line in
                        switch line.type {
                        case .tabLineColumns:
                            Lines(
                                lines: line.tabLines,
                                playingTabNotes: playTabNotes,
                                currentColumnID: currentPartID,
                                zoom: appState.settings.theme.zoom,
                                color: appState.pangoAccentColor
                            )
                        case .emptyLine:
                            Views.Empty()
                        case .comment:
                            CommentLabel(line: line, appState: appState)
                        default:
                            Views.Empty()
                        }
                    }
                }
            }
            .padding(10, [.top, .trailing, .bottom])
            .onUpdate {
                if playTabNotes {
                    Idle {
                        if appState.scene.midiID != tabID {
                            /// Another grid or tab is started; uncheck the toggle button
                            playTabNotes = false
                        }
                        if let tabs = section.tabEvents, tabs != ChordProviderMIDI.shared.snapshot.tabs {
                            /// The tab has changed; stop the player
                            playTabNotes = false
                            Task {
                                await ChordProviderMIDI.shared.stopTab()
                            }
                        }
                        if let tempo = section.tempo, ChordProviderMIDI.shared.snapshot.currentTempo != tempo {
                            Task {
                                await ChordProviderMIDI.shared.setCurrentTempo(tempo)
                            }
                        }
                    }
                }
            }
        }

        /// Monitor the tab player for its current tab
        /// - Note: This will cancel itself when the player is stopped
        private func monitorTabPlayer() {
            Idle(delay: .seconds(0.15), priority: .low) {
                let chordID = ChordProviderMIDI.shared.snapshot.currentMidiID
                if chordID != currentPartID {
                    currentPartID = chordID
                }
                return playTabNotes
            }
        }

        /// Start the tab player
        private func startTabPlayer(_ columns: [Song.Section.Line.Tab]) {
            /// Set this tab as current
            appState.scene.midiID = tabID
            /// Capture stuff
            let columns = columns
            let tempo = section.tempo ?? 128
            Task {
                await ChordProviderMIDI.shared.setCurrentTempo(tempo)
                await ChordProviderMIDI.shared.setTabNotes(columns)
                await ChordProviderMIDI.shared.startTab()
            }
        }
    }
}
