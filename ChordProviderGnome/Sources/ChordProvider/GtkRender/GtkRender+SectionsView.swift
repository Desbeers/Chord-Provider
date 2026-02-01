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
        init(appState: AppState) {
            /// Filter viewable sections
            self.sections = appState.editor.song.sections.filter { ChordPro.Environment.content.contains($0.environment) }
            self.appState = appState
        }
        /// The state of the application
        let appState: AppState
        /// All the sections of the song, suitable for display
        let sections: [Song.Section]
        /// The body of the `View`
        var view: Body {
            switch appState.settings.app.columnPaging {
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
                LyricsSection(section: section, appState: appState)
            case .textblock:
                if !section.label.isEmpty {
                    SectionHeader(section: section)
                }
                let maxLenght = appState.editor.song.metadata.longestLine.lineLength?.count ?? 100
                TextblockSection(section: section, settings: appState.settings, maxLenght: maxLenght)
            case .tab:
                if !appState.editor.song.settings.lyricsOnly {
                    SectionHeader(section: section)
                    TabSection(section: section, settings: appState.settings)
                }
            case .grid:
                if !appState.editor.song.settings.lyricsOnly {
                    SectionHeader(section: section)
                    GridSection(section: section, appState: appState)
                }
            case .strum:
                if !appState.editor.song.settings.lyricsOnly {
                    SectionHeader(section: section)
                    StrumSection(section: section, settings: appState.settings)
                }
            case .repeatChorus:
                let label = section.lines.first?.plain
                /// Check if we have to repeat the whole chorus
                if
                    appState.editor.song.settings.repeatWholeChorus,
                    let lastChorus = appState.editor.song.sections.last(
                        where: { $0.environment == .chorus && $0.arguments?[.label] == section.lines.first?.plain }
                    ) {
                    SectionHeader(label: label, section: lastChorus)
                    LyricsSection(section: lastChorus, appState: appState)
                } else {
                    RepeatChorus(label: label, section: section)
                }
            case .comment:
                CommentLabel(comment: section.lines.first?.plain ?? "Empty Comment", settings: appState.settings)
            case .image:
                ImageSection(section: section, settings: appState.settings)
            default:
                /// Not supported or not a viewable environment
                Views.Empty()
            }
        }
    }
}
