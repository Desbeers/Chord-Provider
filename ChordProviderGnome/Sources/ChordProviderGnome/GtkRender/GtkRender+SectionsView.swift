//
//  GtkRender+SectionsView.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
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
            self.sections = appState.wrappedValue.editor.song.sections.filter(\.environment.hasContent)
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
        @ViewBuilder
        private func sectionPart(_ section: Song.Section) -> Body {
            switch section.environment {
            case .verse, .bridge, .chorus, .custom:
                SectionHeader(section: section, appState: appState)
                LyricsSection(section: section, appState: appState)
            case .textblock:
                if !section.label.isEmpty {
                    SectionHeader(section: section, appState: appState)
                }
                TextblockSection(section: section, appState: appState)
            case .tab:
                if !appState.editor.coreSettings.lyricsOnly {
                    SectionHeader(section: section, appState: appState)
                    TabSection(
                        section: section,
                        appState: $appState
                    )
                }
            case .grid:
                if !appState.editor.coreSettings.lyricsOnly {
                    SectionHeader(section: section, appState: appState)
                    GridSection(
                        section: section,
                        appState: $appState
                    )
                }
            case .repeatChorus:
                let label = section.lines.first?.plain
                /// Check if we have to repeat the whole chorus
                if
                    appState.editor.coreSettings.repeatWholeChorus,
                    let lastChorus = appState.editor.song.sections.last(
                        where: { $0.environment == .chorus && $0.arguments?[.label] == section.lines.first?.plain }
                    ) {
                    SectionHeader(label: label, section: lastChorus, appState: appState)
                    LyricsSection(section: lastChorus, appState: appState)
                } else {
                    RepeatChorus(label: label, section: section, appState: appState)
                }
            case .comment:
                if let line = section.lines.first {
                    CommentLabel(line: line, appState: appState)
                }
            case .chordDiagram:
                if let line = section.lines.first {
                    ChordDiagram(line: line, appState: appState)
                }
            case .image:
                ImageSection(section: section, coreSettings: appState.editor.coreSettings)
            default:
                /// Not supported or not a viewable environment
                Views.Empty()
            }
        }
    }
}
