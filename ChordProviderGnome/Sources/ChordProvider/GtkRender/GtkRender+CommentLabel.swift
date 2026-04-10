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
        /// Init the `View`
        /// - Parameters 
        ///   - line: The current line
        ///   - maxLenght: The maximum length of a single line
        init(line: Song.Section.Line, maxLenght: Int) {
            self.line = line
            self.maxLenght = maxLenght
        }
        /// The current line of the song
        let line: Song.Section.Line
        /// The maximum length of a single line
        let maxLenght: Int
        /// The body of the `View`
        var view: Body {
            HStack(spacing: 10) {
                Symbol(icon: .default(icon: .userInvisible))
                let lines = line.wholeTextWithMarkup(split: maxLenght).toElementWrapper
                ForEach(lines) { line in
                    Text(line.content)
                        .useMarkup()
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
