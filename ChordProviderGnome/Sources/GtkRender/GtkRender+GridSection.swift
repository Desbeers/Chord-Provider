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
            self.height = Int(20 * settings.app.zoom)
        }
        /// The current section of the song
        let section: Song.Section
        /// The settings of the application
        let settings: AppSettings
        /// The height of the grid rows
        let height: Int
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if let elements = line.gridColumns?.grids {
                            ForEach(elements, horizontal: true) { element in
                                VStack {
                                    ForEach(element.cells) { cell in
                                        ForEach(cell.parts, horizontal: true) { item in
                                            part(part: item)
                                        }
                                    }
                                }
                                .vexpand(false)
                                .valign(.start)
                            }
                        }
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
                    default:
                        Widgets.Empty()
                    }
                }
            }
            .padding(10)
        }

        @ViewBuilder func part(part: Song.Section.Line.Part) -> Body {
            /// - Note: I cannot set the style conditional
            if let chord = part.chordDefinition {
                Box {
                    Text(part.withMarkup(chord))
                        .useMarkup()
                        .style(.gridChord)
                        .vexpand()
                }
                .valign(.center)
                .frame(minHeight: height)
                .padding(5, .trailing)
            } else if let strum = part.strum {
                Box {
                    Widgets.BundleImage(strum: strum)
                        .pixelSize(Int(14 * settings.app.zoom))
                        .style(.svgIcon)
                        .vexpand()
                }
                .valign(.center)
                .frame(minHeight: height)
                .padding(5, .trailing)
            } else {
                Box {
                    Text(part.withMarkup(part.text ?? " "))
                        .useMarkup()
                        .style(.grid)
                        .vexpand()
                }
                .valign(.center)
                .frame(minHeight: height)
                .padding(5, .trailing)
            }
        }
    }
}
