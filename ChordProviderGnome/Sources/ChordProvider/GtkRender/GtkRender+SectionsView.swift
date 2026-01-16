//
//  GtkRender+SectionsView.swift
//  ChordProvider
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
                SectionHeader(section: section)
                LyricsSection(section: section, settings: settings, coreSettings: song.settings)
            case .textblock:
                if !section.label.isEmpty {
                    SectionHeader(section: section)
                }
                let maxLenght = song.metadata.longestLine.lineLength?.count ?? 100
                TextblockSection(section: section, settings: settings, maxLenght: maxLenght)
            case .tab:
                if !song.settings.lyricsOnly {
                    SectionHeader(section: section)
                    TabSection(section: section, settings: settings)
                }
            case .grid:
                if !song.settings.lyricsOnly {
                    SectionHeader(section: section)
                    GridSection(section: section, settings: settings, coreSettings: song.settings)
                }
            case .strum:
                if !song.settings.lyricsOnly {
                    SectionHeader(section: section)
                    StrumSection(section: section, settings: settings)
                }
            case .repeatChorus:
                let label = section.lines.first?.plain
                /// Check if we have to repeat the whole chorus
                if
                    song.settings.repeatWholeChorus,
                    let lastChorus = song.sections.last(
                        where: { $0.environment == .chorus && $0.arguments?[.label] == section.lines.first?.plain }
                    ) {
                    SectionHeader(label: label, section: lastChorus)
                    LyricsSection(section: lastChorus, settings: settings, coreSettings: song.settings)
                } else {
                    RepeatChorus(label: label, section: section)
                }
            case .comment:
                CommentLabel(comment: section.lines.first?.plain ?? "Empty Comment", settings: settings)
            case .image:
                ImageSection(section: section, settings: settings, coreSettings: song.settings)
            default:
                /// Not supported or not a viewable environment
                Views.Empty()
            }
        }
    }
}
