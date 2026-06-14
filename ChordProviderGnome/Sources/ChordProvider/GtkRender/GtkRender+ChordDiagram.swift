//
//  GtkRender+CommentLabel.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension GtkRender {

    /// The `View` for a chord diagram
    struct ChordDiagram: View {
        /// The current line of the song
        let line: Song.Section.Line
        /// The state of the application
        let appState: AppState
        /// The body of the `View`
        var view: Body {
            if let parts = line.parts {
                ForEach(parts, horizontal: true) { part in
                    if let chord = part.content.getChord, chord.definition.knownChord {
                        VStack(spacing: 0) {
                            Views.MidiPlayerButton(
                                chord: chord.definition,
                                coreSettings: appState.editor.coreSettings,
                            )
                            Views.ChordDiagram(
                                chord: chord.definition,
                                width: 80 * appState.settings.theme.zoom,
                                coreSettings: appState.editor.coreSettings
                            )
                            .id(appState.settings.theme.zoom)
                        }
                    }
                }
            }
        }
    }
}
