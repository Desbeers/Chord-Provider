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

    struct SectionsView: View {

        let song: Song

        var view: Body {
            ForEach(song.sections) { section in

                if !section.label.isEmpty {
                    Text("<span size='large' weight='bold'>\(section.label)</span>")
                        .useMarkup()
                        .halign(.start)
                        .padding(10, .vertical)
                }
                    switch section.environment {
                    case .verse, .bridge, .chorus:
                        LyricsSection(section: section)
                    case .textblock:
                        TextblockSection(section: section)
                    case .tab:
                        TabSection(section: section)
                    case .comment:
                        CommentLabel(comment: section.lines.first?.plain ?? "Empty Comment")
                    default:
                        /// Not supported or not a viewable environment
                        EmptyView()
                    }
            }
        }
    }
}
