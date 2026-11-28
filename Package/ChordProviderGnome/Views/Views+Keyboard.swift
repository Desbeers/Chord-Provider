//
//  Views+Keyboard.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import ChordProviderMIDI
import Adwaita

extension Views {

    /// The `View` for midi keyboard monitoring
    struct Keyboard: View {

        /// Init the keyboard monitor
        init(appState: AppState) {
            self.appState = appState
            if appState.scene.keyboardChord.notes.isEmpty {
                self.notes = "Nothing is playing"
            } else {
                self.notes = "Playing: \(appState.scene.keyboardChord.notes.map(\.display).joined(separator: ", "))"
            }
            self.emptyChord = ChordDefinition(instrument: appState.settings.core.instrument)
            self.emptyChord.status = .correct
            self.match = appState.scene.keyboardChord.chord
        }
        /// The state of the application
        let appState: AppState
        /// The notes that are currently plpaying
        let notes: String
        /// Empty chord diagram
        var emptyChord: ChordDefinition
        /// Matched chord
        let match: ChordDefinition?
        /// The body of the `View`
        var view: Body {
            VStack {
                Box {
                    Text("\(match?.display ?? "")")
                        .title1()
                    Views.ChordDiagram(
                        chord: match ?? emptyChord,
                        width: 180,
                        coreSettings: appState.settings.core
                    )
                }
                .transition(.crossfade)
            }
            .vexpand()
            .topToolbar {
                HeaderBar.empty()
            }
            .bottomToolbar {
                Text(notes)
                .heading()
                .padding()
            }
        }
    }
}
