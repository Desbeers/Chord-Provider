//
//  GtkRender+LyricsSection.swift
//  ChordProvider
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
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The maximum length of a single line
        let maxLenght: Int
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
                                coreSettings: coreSettings
                            )
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
            .padding(10)
        }
    }
}
