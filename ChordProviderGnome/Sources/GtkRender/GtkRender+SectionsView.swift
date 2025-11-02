//
//  GtkRender+SectionsView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for all sections
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
                    if !section.label.isEmpty {
                        HeaderView(section: section, settings: settings)
                    }
                    let maxLenght = song.metadata.longestLine.lineLength?.count ?? 100
                    TextblockSection(section: section, settings: settings, maxLenght: maxLenght)
                case .tab:
                    if !settings.core.lyricsOnly {
                        HeaderView(section: section, settings: settings)
                        TabSection(section: section, settings: settings)
                    }
                case .grid:
                    if !settings.core.lyricsOnly {
                        HeaderView(section: section, settings: settings)
                        GridSection(section: section, settings: settings)
                    }
                case .strum:
                    if !settings.core.lyricsOnly {
                        HeaderView(section: section, settings: settings)
                        StrumSection(section: section, settings: settings)
                    }
                case .repeatChorus:
                    let label = section.lines.first?.plain
                    /// Check if we have to repeat the whole chorus
                    if
                        settings.core.repeatWholeChorus,
                        let lastChorus = song.sections.last(
                            where: { $0.environment == .chorus && $0.arguments?[.label] == section.lines.first?.plain }
                        ) {
                        HeaderView(label: label, section: lastChorus, settings: settings)
                        LyricsSection(section: lastChorus, settings: settings)
                    } else {
                        RepeatChorus(label: label, section: section, settings: settings)
                    }
                case .comment:
                    CommentLabel(comment: section.lines.first?.plain ?? "Empty Comment", settings: settings)
                case .image:
                    ImageSection(section: section, settings: settings)
                default:
                    /// Not supported or not a viewable environment
                    EmptyView()
                }
            }
        }
    }
}
