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
        let settings: ChordProviderSettings

        var view: Body {
            ForEach(song.sections) { section in
                switch section.environment {
                case .verse, .bridge, .chorus:
                    HeaderView(section: section, settings: settings)
                    LyricsSection(section: section, settings: settings)
                case .textblock:
                    TextblockSection(section: section)
                case .tab:
                    if !settings.options.lyricOnly {
                        HeaderView(section: section, settings: settings)
                        TabSection(section: section)
                    }
                case .repeatChorus:
                    HeaderView(section: section, settings: settings)
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
