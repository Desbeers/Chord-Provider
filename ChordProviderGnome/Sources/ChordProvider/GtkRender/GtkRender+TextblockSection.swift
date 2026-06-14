//
//  GtkRender+TextblockSection.swift
//  ChordProvider
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a textblock section
    struct TextblockSection: View {
        /// Init the `View`
        /// - Parameters:
        ///   - section: The current section
        ///   - appState: The state of the application
        init(section: Song.Section, appState: AppState) {
            self.section = section
            self.appState = appState
            self.halign = Utils.getTextAlignment(section.arguments)
            self.flush = Utils.getTextFlush(section.arguments)
        }
        /// The current section of the song
        let section: Song.Section
        /// The state of the application
        let appState: AppState
        /// The horizontal alignment
        let halign: Alignment
        /// The alignment of multi-lines
        let flush: Alignment
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    VStack {
                        switch line.type {
                        case .songLine:
                            let lines = line.wholeText(split: appState.editor.song.metadata.longestLineLenght).toElementWrapper
                            ForEach(lines) { line in
                                Text(line.content)
                                    .useMarkup()
                                    .zoom(appState.settings.theme.zoom)
                                    .style(.sectionTextblock)
                                    .halign(flush)
                            }
                        case .emptyLine:
                            EmptyLine()
                        case .comment:
                            CommentLabel(line: line, appState: appState)
                        case .chordDiagram:
                            ChordDiagram(line: line, appState: appState)
                        default:
                            Views.Empty()
                        }
                    }
                    .halign(flush)
                }
            }
            .halign(halign)
            .padding()
        }
    }
}
