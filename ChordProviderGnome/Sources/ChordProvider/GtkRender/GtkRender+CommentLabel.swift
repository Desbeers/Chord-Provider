//
//  GtkRender+CommentLabel.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension GtkRender {

    /// The `View` for a comment label
    struct CommentLabel: View {
        /// The current line of the song
        let line: Song.Section.Line
        /// The state of the application
        let appState: AppState
        /// The body of the `View`
        var view: Body {
            HStack(spacing: 10) {
                Symbol(icon: .default(icon: .userInvisible))
                    .pixelSize(Int(14 * appState.settings.theme.zoom))
                let lines = line.wholeText(split: appState.editor.song.metadata.longestLineLenght).toElementWrapper
                ForEach(lines) { line in
                    Text(Utils.convertSimpleLinks(line.content))
                        .useMarkup()
                        .zoom(appState.settings.theme.zoom)
                        .halign(.start)
                }
            }
            .style(.commentLabel)
            .card()
            .halign(.start)
            .padding()
        }
    }
}
