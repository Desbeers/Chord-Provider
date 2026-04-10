//
//  GtkRender+TabSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a tab section
    struct TabSection: View {
        /// The current section of the song
        let section: Song.Section
        /// The maximum length of a single line
        let maxLenght: Int
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        Text(line.plain ?? "")
                            .style(.sectionTab)
                            .halign(.start)
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(line: line, maxLenght: maxLenght)
                    default:
                        Views.Empty()
                    }
                }
            }
            .padding()
        }
    }
}
