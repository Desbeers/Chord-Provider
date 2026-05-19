//
//  GtkRender+TabSection+Columns.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender.TabSection {

    /// The `View` for columns of a tab section
    struct Columns: View {
        /// Init the `View`
        /// - Parameters:
        ///   - columns: The Tab columns
        ///   - coreSettings: The core settings
        ///   - appState: The state of the application
        init(
            columns: [Song.Section.Line.Tab],
            coreSettings: ChordProviderSettings,
            appState: Binding<AppState>
        ) {
            self.columns = columns
            self.coreSettings = coreSettings
            self._appState = appState
        }
        /// The columns of the grid
        let columns: [Song.Section.Line.Tab]
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The state of the application
        @Binding var appState: AppState
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
                    Toggle(
                        icon: .default(icon: playTabNotes ? .mediaPlaybackStop : .mediaPlaybackStart),
                        isOn: $playTabNotes
                    ) {
                        if playTabNotes {
                            startTabPlayer()
                            /// Monitor the tab player
                            monitorTabPlayer()
                        } else {
                            Idle {
                                currentPartID = -1
                            }
                            Task {
                                await Utils.MidiPlayer.shared.stopTab()
                            }
                        }
                    }
                    .halign(.start)
                    .flat()
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
                        /// Another grid or tab is started; uncheck the toggle button and reset current part
                        playTabNotes = false
                        currentPartID = -1
                    }
                    if playTabNotes, columns != Utils.MidiPlayer.shared.getCurrentTab {
                        /// The tab has changed; restart the player
                        currentPartID = -1
                        playTabNotes = false
                        Task {
                            await Utils.MidiPlayer.shared.stopTab()
                        }
                    }
                }
            }
        }

        private func event(event: Song.Section.Line.Tab.Event, column: Int) -> AnyView {
            Box {
                switch event.content {
                case .rest:
                    Text("-")
                        .style(.dimmed)
                case .text(let text):
                    Text(text)
                        .halign(.start)
                case .barLine:
                    Text("|")
                case .fret(let fret):
                    Text("\(fret)")
                        .style(column == currentPartID && playTabNotes ? .chordHighlight : .none)
                case let .transition(from, to, transition):
                    Text("\(from)\(transition.display)\(to)")
                        .style(column == currentPartID && playTabNotes ? .chordHighlight : .none)
                }
            }
            .style(.sectionTab)
            .halign(.center)
            .id(playTabNotes.description + currentPartID.description)
        }
        
        /// Monitor the tab player for its current tab
        /// - Note: This will cancel itself when the player is stopped
        private func monitorTabPlayer() {
            Idle(delay: .seconds(0.005)) {
                let chordID = Utils.MidiPlayer.shared.getCurrentMidiID
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
            // /// Capture the tab columns
            let columns = columns
            Task {
                await Utils.MidiPlayer.shared.setTabNotes(
                    tabColumns: columns
                )
                await Utils.MidiPlayer.shared.startTab()
            }
        }
    }
}
