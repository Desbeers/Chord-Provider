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
        init(section: Song.Section, settings: AppSettings, coreSettings: ChordProviderSettings) {
            /// Convert the grids into columns
            self.section = section.gridColumns()
            self.settings = settings
            self.coreSettings = coreSettings
        }
        /// The current section of the song
        let section: Song.Section
        /// The settings of the application
        let settings: AppSettings

        let coreSettings: ChordProviderSettings
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
                        CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
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
                    SingleChord(part: part, settings: coreSettings)
                } else if let strum = part.strum {
                    Widgets.BundleImage(strum: strum)
                        .pixelSize(Int(14 * settings.app.zoom))
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
