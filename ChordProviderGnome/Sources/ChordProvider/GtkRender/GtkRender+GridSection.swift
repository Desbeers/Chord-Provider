//
//  GtkRender+GridSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a grid section
    struct GridSection: View {
        /// The current section of the song
        let section: Song.Section
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The state of the application
        @Binding var appState: AppState
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .gridLineColumns:
                        if let columns: [Song.Section.Line.Grid] = line.gridColumns {
                            Columns(
                                columns: columns,
                                coreSettings: coreSettings,
                                appState: $appState,
                                tempo: section.tempo

                            )
                        } else {
                            Text("The grid is empty")
                        }
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(line: line, maxLenght: appState.editor.song.metadata.longestLineLenght)
                    default:
                        Views.Empty()
                    }
                }
            }
            .padding(10)

        }
    }
}
