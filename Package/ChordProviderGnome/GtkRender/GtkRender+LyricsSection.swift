//
//  GtkRender+LyricsSection.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a lyrics section
    struct LyricsSection: View {

        /// The current section of the song
        let section: Song.Section
        /// The state of the application
        let appState: AppState
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        PartsView(
                            parts: line.parts,
                            lineHasLyrics: line.hasLyrics,
                            lineHasChords: appState.settings.core.lyricsOnly ? false : line.hasChords,
                            appState: appState
                        )
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(line: line, appState: appState)
                    case .chordDiagram:
                        ChordDiagram(line: line, appState: appState)
                    default:
                        Views.Empty()
                    }
                }
            }
            .padding(10)
        }
    }
}
