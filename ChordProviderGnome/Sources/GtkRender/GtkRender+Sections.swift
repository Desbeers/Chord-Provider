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
        let settings: AppSettings

        var view: Body {
            ForEach(song.sections) { section in
                switch section.environment {
                case .verse, .bridge, .chorus:
                    HeaderView(section: section, settings: settings)
                    LyricsSection(section: section, settings: settings)
                case .textblock:
                    TextblockSection(section: section)
                case .tab:
                    if !settings.core.lyricOnly {
                        HeaderView(section: section, settings: settings)
                        TabSection(section: section)
                    }
                case .grid:
                    if !settings.core.lyricOnly {
                        HeaderView(section: section, settings: settings)
                        GridSection(section: section, settings: settings)
                    }
                case .repeatChorus:
                    let label = section.lines.first?.plain ?? section.label
                    /// Check if we have to repeat the whole chorus
                    if
                        settings.core.repeatWholeChorus,
                        let lastChorus = song.sections.last(
                            where: { $0.environment == .chorus && $0.arguments?[.label] == section.lines.first?.plain }
                        ) {
                        HeaderView(label: label, section: lastChorus, settings: settings)
                        LyricsSection(section: lastChorus, settings: settings)
                    } else {
                        HeaderView(label: label, section: section, settings: settings)
                    }
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
