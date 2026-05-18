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
        /// Init the `View`
        /// - Parameters:
        ///   - section: The Grid section
        ///   - coreSettings: The core settings
        ///   - appState: The state of the application
        init(
            section: Song.Section,
            coreSettings: ChordProviderSettings,
            appState: Binding<AppState>,
            maxLenght: Int
        ) {
            self.section = section
            self.coreSettings = coreSettings
            self._appState = appState
            self.maxLenght = maxLenght
        }
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The state of the application
        @Binding var appState: AppState
        /// The current section of the song
        let section: Song.Section
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
                                appState: $appState
                            )
                        } else {
                            Text("The grid is empty")
                        }
                    // case .songLine:
                    //     Text(line.plain ?? "")
                    //         .style(.sectionTab)
                    //         .halign(.start)
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
