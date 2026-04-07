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
        /// - Parameter appState: The state of the application
        init(appState: Binding<AppState>) {
            /// Filter viewable sections
            self.sections = appState.wrappedValue.editor.song.sections.filter {
                ChordPro.Environment.content.contains($0.environment)
            }
            self._appState = appState
        }
        /// The state of the application
        @Binding var appState: AppState
        /// All the sections of the song, suitable for display
        let sections: [Song.Section]
        /// The body of the `View`
        var view: Body {
            switch appState.settings.app.columnPaging {
            case true:
                Widgets.Columns(sections) { section in
                    sectionPart(section)
                }
                .transition(.rotateLeftRight)
            case false:
                ForEach(sections) { section in
                    sectionPart(section)
                }
            }
        }

        /// A `View` with a single section
        /// - Parameter section: The current section
        /// - Returns: A `View`
        @ViewBuilder private func sectionPart(_ section: Song.Section) -> Body {
            switch section.environment {
            case .verse, .bridge, .chorus:
                SectionHeader(section: section)
                LyricsSection(section: section, coreSettings: appState.editor.coreSettings)
            case .textblock:
                if !section.label.isEmpty {
                    SectionHeader(section: section)
                }
                let maxLenght = appState.editor.song.metadata.longestLine.lineLength?.count ?? 100
                TextblockSection(section: section, maxLenght: maxLenght)
            case .tab:
                if !appState.editor.coreSettings.lyricsOnly {
                    SectionHeader(section: section)
                    TabSection(section: section)
                }
            case .grid:
                if !appState.editor.coreSettings.lyricsOnly {
                    SectionHeader(section: section)
                    GridSection(
                        section: section,
                        coreSettings: appState.editor.coreSettings,
                        appState: $appState
                    )
                }
            case .strum:
                if !appState.editor.coreSettings.lyricsOnly {
                    SectionHeader(section: section)
                    StrumSection(section: section, zoom: appState.settings.theme.zoom)
                }
            case .repeatChorus:
                let label = section.lines.first?.plain
                /// Check if we have to repeat the whole chorus
                if
                    appState.editor.coreSettings.repeatWholeChorus,
                    let lastChorus = appState.editor.song.sections.last(
                        where: { $0.environment == .chorus && $0.arguments?[.label] == section.lines.first?.plain }
                    ) {
                    SectionHeader(label: label, section: lastChorus)
                    LyricsSection(section: lastChorus, coreSettings: appState.editor.coreSettings)
                } else {
                    RepeatChorus(label: label, section: section)
                }
            case .comment:
                CommentLabel(comment: section.lines.first?.plain)
            case .image:
                ImageSection(section: section, coreSettings: appState.editor.coreSettings)
            default:
                /// Not supported or not a viewable environment
                Views.Empty()
            }
        }
    }
}
