//
//  GtkRender+GridSection+Columns.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender.GridSection {

    /// The `View` for columns of a grid section
    struct Columns: View {
        /// The columns of the grid
        let columns: [Song.Section.Line.Grid]
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The state of the application
        @Binding var appState: AppState
        /// The optional tempo
        let tempo: Int?
        /// Bool to play the chords with MIDI
        @Binding var playGridChords: Bool
        /// The part that is currently playing with MIDI 
        @Binding var currentPartID: Int
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(columns, horizontal: true) { column in
                    Box {
                        ForEach(column.cells.flatMap(\.parts), horizontal: false) { item in
                            part(part: item)
                        }
                        .homogeneous()
                    }
                    .homogeneous()
                }
            }
            .padding(10)
        }

        /// Render a part of the grid
        /// - Parameter part: The part to render
        /// - Returns: A `View`
        private func part(part: Song.Section.Line.Part) -> AnyView {
            Box {
                switch part.content {
                case let .chord(definition, _, _):
                    if definition.isSilent {
                        Text(" . ")
                            .style(.dimmed)
                    } else {
                        GtkRender.SingleChord(part: part, coreSettings: coreSettings)
                            .halign(.center)
                            .style(part.dimmed ? .dimmed : .none)
                            .id(definition)
                    }
                case let .anyChord(textPart, _, _),
                    let .textChord(textPart),
                    let .text(textPart),
                    let .margin(textPart):
                    Text(textPart.display)
                        .useMarkup()
                case let .strum(symbol):
                    Widgets.BundleImage(strum: symbol)
                        .pixelSize(Int(14 * appState.settings.theme.zoom))
                        .style(.svgIcon)
                        .halign(.center)
                case let .barLine(symbol):
                    Text(symbol.display)
                        .style(.sectionGrid)
                        .halign(.center)
                case let .strumPattern(symbol):
                    Text(symbol.display)
                        .style(.sectionGrid)
                        .halign(.center)
                case let .repeating(symbol):
                    Text(symbol.rawValue)
                        .style(.sectionGrid)
                        .halign(.center)
                case .lyric:
                    // A grid has no lyrics, comment or textblock
                    Views.Empty()
                }
            }
            .style(part.id == currentPartID && playGridChords ? .chordHighlight : .none)
            .halign(.center)
            .valign(.center)
            .padding(2, .horizontal)
            .id(part.description + playGridChords.description + currentPartID.description)
        }
    }
}
