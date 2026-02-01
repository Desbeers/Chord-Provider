//
//  GtkRender+GridSection.swift
//  ChordProvider
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
        init(section: Song.Section, appState: AppState) {
            /// Convert the grids into columns
            self.section = section.gridColumns()
            self.appState = appState
        }
        /// The state of the application
        let appState: AppState
        /// The current section of the song
        let section: Song.Section
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if let elements = line.gridColumns?.grids {
                            ForEach(elements, horizontal: true) { element in
                                Box {
                                    ForEach(element.cells, horizontal: false) { cell in
                                        ForEach(cell.parts, horizontal: true) { item in
                                            part(part: item)
                                        }
                                    }
                                    .homogeneous()
                                }
                                .homogeneous()
                            }
                        }
                    case .emptyLine:
                        EmptyLine()
                    case .comment:
                        CommentLabel(comment: line.plain ?? "Empty Comment", settings: appState.settings)
                    default:
                        Views.Empty()
                    }
                }
            }
            .padding(10)
        }

        @ViewBuilder func part(part: Song.Section.Line.Part) -> Body {
            /// - Note: I cannot set the style conditional
            Box {
                if part.chordDefinition != nil {
                    SingleChord(part: part, appState: appState)
                } else if let strum = part.strum {
                    Widgets.BundleImage(strum: strum)
                        .pixelSize(Int(14 * appState.settings.app.zoom))
                        .style(.svgIcon)
                } else {
                    Text(part.withMarkup(part.text ?? " "))
                        .useMarkup()
                        .style(.sectionGrid)
                        .padding(5, .leading)
                }
            }
            .homogeneous()
            .valign(.center)
            .padding(2)
        }
    }
}
