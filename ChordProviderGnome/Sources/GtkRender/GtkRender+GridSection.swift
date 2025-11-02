//
//  GtkRender+GridSection.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a grid section
    struct GridSection: View {
        /// Init the struct
        init(section: Song.Section, settings: AppSettings) {
            /// Convert the grids into columns
            self.section = section.gridColumns()
            self.settings = settings
        }
        let section: Song.Section
        let settings: AppSettings
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if let elements = line.gridColumns?.grids {
                            ForEach(elements, horizontal: true) { element in
                                HStack {
                                    ForEach(element.parts) { part in
                                        Text(part.text ?? "")
                                            .style(part.chordDefinition == nil ? .standard : .grid)
                                            .halign(.start)
                                            .padding(5, [.trailing, .bottom])
                                    }
                                }
                            }
                        }
                    case .emptyLine:
                        Text(" ")
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
