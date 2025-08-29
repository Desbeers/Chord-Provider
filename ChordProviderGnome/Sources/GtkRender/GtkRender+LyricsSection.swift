//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    struct LyricsSection: View {
        let section: Song.Section
        let settings: ChordProviderSettings
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                        switch line.type {
                        case .songLine:
                            if settings.options.lyricOnly {
                                Text(line.plain ?? "")
                                    .halign(.start)
                            } else if let parts = line.parts {
                                PartsView(
                                    parts: parts,
                                    settings: settings
                                )
                            }
                        case .emptyLine:
                            Text(" ")
                        case .comment:
                            CommentLabel(comment: line.plain ?? "Empty Comment")
                        default:
                            EmptyView()
                        }
                }
            }
            .padding(10)
        }
    }
}
