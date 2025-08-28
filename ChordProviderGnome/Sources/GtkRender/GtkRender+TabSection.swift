//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    struct TabSection: View {
        let section: Song.Section
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                        switch line.type {
                        case .songLine:
                            Text("<tt>\(line.plain ?? "")</tt>")
                                .useMarkup()
                                .wrap()
                                .halign(.start)
                        case .emptyLine:
                            Text(" ")
                        case .comment:
                            CommentLabel(comment: line.plain ?? "Empty Comment")
                        default:
                            EmptyView()
                        }
                }
            }
            .padding(10)
        }
    }
}
