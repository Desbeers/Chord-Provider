//
//  GtkRender+TabSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a tab section
    struct TabSection: View {
        /// The current section of the song
        let section: Song.Section
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The state of the application
        @Binding var appState: AppState
        /// The maximum length of a single line
        let maxLenght: Int
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .tabLineColumns:
                        if let columns = line.tabColumns {
                            Columns(
                                columns: columns,
                                coreSettings: coreSettings,
                                appState: $appState,
                                tempo: section.tempo
                            )
                        } else {
                            Text("The tab is empty")
                        }
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(line: line, maxLenght: maxLenght)
                    default:
                        Views.Empty()
                    }
                }
            }
            .padding()
        }
    }
}
