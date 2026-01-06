//
//  GtkRender+LyricsSection.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a lyrics section
    struct LyricsSection: View {
        /// The current section of the song
        let section: Song.Section
        /// The settings of the application
        let settings: AppSettings
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if coreSettings.lyricsOnly {
                            Text(line.plain ?? "")
                                .halign(.start)
                        } else if let parts = line.parts {
                            PartsView(
                                parts: parts,
                                settings: coreSettings
                            )
                        }
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
                    default:
                        Widgets.Empty()
                    }
                }
            }
            .padding(10)
        }
    }
}
