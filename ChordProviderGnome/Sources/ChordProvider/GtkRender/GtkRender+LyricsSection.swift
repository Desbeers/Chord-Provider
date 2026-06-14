//
//  GtkRender+LyricsSection.swift
//  ChordProvider
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
                        if appState.editor.coreSettings.lyricsOnly {
                            Text(line.plain ?? "")
                                .halign(.start)
                        } else if let parts = line.parts {
                            PartsView(
                                parts: parts,
                                lineHasLyrics: line.hasLyrics,
                                lineHasChords: line.hasChords,
                                appState: appState
                            )
                        }
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
