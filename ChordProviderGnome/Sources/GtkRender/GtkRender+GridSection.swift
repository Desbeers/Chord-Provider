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
                                        ForEach(cell.parts, horizontal: true) { part in
                                            /// - Note: I cannot set the style conditional
                                            if let chord = part.chordDefinition {
                                                Box {
                                                    Text(chord.display)
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
                                                    Text(part.text ?? " ")
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
                                .frame(maxHeight: 3 * height)
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
    }
}
