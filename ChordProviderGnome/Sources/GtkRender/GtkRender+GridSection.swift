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
        /// Init the `View`
        init(section: Song.Section, settings: AppSettings) {
            /// Convert the grids into columns
            self.section = section.gridColumns()
            self.settings = settings
        }
        /// The current section of the song
        let section: Song.Section
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if let elements = line.gridColumns?.grids {
                            ForEach(elements, horizontal: true) { element in
                                HStack {
                                    ForEach(element.cells) { cell in
                                        VStack {
                                            ForEach(cell.parts, horizontal: true) { part in
                                                /// - Note: I cannot set the style conditional
                                                if let chord = part.chordDefinition {
                                                    Text(chord.display)
                                                        .style(.grid)
                                                        .padding(5, [.trailing, .bottom])
                                                } else if let strum = part.strum {
                                                    Text(strum.symbol)
                                                        .style(.standard)
                                                        .padding(5, [.trailing, .bottom])
                                                } else {
                                                    Text(part.text ?? " ")
                                                        .style(.standard)
                                                        .padding(5, [.trailing, .bottom])
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    case .emptyLine:
                        Text(" ")
                    case .comment:
                        CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
                    default:
                        Widgets.Empty()
                    }
                }
            }
            .padding(10)
        }
    }
}
