//
//  GtkRender+TextblockSection.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    struct TextblockSection: View {
        let section: Song.Section
        let settings: AppSettings
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        Text(line.plain ?? "", font: .standard, zoom: settings.app.zoom)
                            .useMarkup()
                            .wrap()
                            .halign(.start)
                    case .emptyLine:
                        Text(" ", font: .standard, zoom: settings.app.zoom)
                            .useMarkup()
                    case .comment:
                        CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
                    default:
                        EmptyView()
                    }
                }
            }
            .padding(10)
        }
    }
}
