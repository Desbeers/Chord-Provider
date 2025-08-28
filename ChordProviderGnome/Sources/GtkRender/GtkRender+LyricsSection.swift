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

    struct LyricsSection: View {
        let section: Song.Section
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                        switch line.type {
                        case .songLine:
                            if let parts = line.parts {
                                PartsView(
                                    parts: parts
                                )
                            }
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
