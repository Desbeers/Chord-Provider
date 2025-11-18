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
        /// Init the `View`
        init(song: Song, settings: AppSettings) {
            /// Filter viewable sections
            self.sections = song.sections.filter { ChordPro.Environment.content.contains($0.environment) }
            self.song = song
            self.settings = settings
        }
        /// All the sections of the song, suitable for display
        let sections: [Song.Section]
        /// The whole song
        let song: Song
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            switch settings.app.columnPaging {
            case true:
                Widgets.Columns(sections) { section in
                    sectionPart(section)
                }
            case false:
                ForEach(sections) { section in
                    sectionPart(section)
                }
            }
        }
        
        /// A `View` with a single section
        /// - Parameter section: The current section
        /// - Returns: A `View`
        @ViewBuilder
        private func sectionPart(_ section: Song.Section) -> Body {
            switch section.environment {
            case .verse, .bridge, .chorus:
                SectionHeader(section: section, settings: settings)
                LyricsSection(section: section, settings: settings)
            case .textblock:
                if !section.label.isEmpty {
                    SectionHeader(section: section, settings: settings)
                }
                let maxLenght = song.metadata.longestLine.lineLength?.count ?? 100
                TextblockSection(section: section, settings: settings, maxLenght: maxLenght)
            case .tab:
                if !settings.core.lyricsOnly {
                    SectionHeader(section: section, settings: settings)
                    TabSection(section: section, settings: settings)
                }
            case .grid:
                if !settings.core.lyricsOnly {
                    SectionHeader(section: section, settings: settings)
                    GridSection(section: section, settings: settings)
                }
            case .strum:
                if !settings.core.lyricsOnly {
                    SectionHeader(section: section, settings: settings)
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
                    SectionHeader(label: label, section: lastChorus, settings: settings)
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
                Widgets.Empty()
            }
        }
    }
}
