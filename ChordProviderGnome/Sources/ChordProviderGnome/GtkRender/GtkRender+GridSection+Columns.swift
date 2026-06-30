//
//  GtkRender+GridSection+Columns.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender.GridSection {

    /// The `View` for columns of a grid section
    struct Columns: View {
        /// The columns of the grid
        let columns: [Song.Section.Line.Grid]
        /// Bool if the the chords areplaying with MIDI
        let playingGridChords: Bool
        /// The part that is currently playing with MIDI 
        let currentPartID: Int
        /// The state of the application
        let appState: AppState
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
                            .zoom(appState.settings.theme.zoom)
                            .style(.dimmed)
                    } else {
                        GtkRender.SingleChord(
                            part: part,
                            highlight: part.id == currentPartID && playingGridChords,
                            appState: appState
                        )
                        .halign(.center)
                        .style(part.dimmed ? .dimmed : .noStyle)
                    }
                case let .anyChord(textPart, _, _),
                    let .textChord(textPart),
                    let .text(textPart),
                    let .margin(textPart):
                    Text(textPart.display)
                        .useMarkup()
                        .zoom(appState.settings.theme.zoom)
                case let .strum(symbol):
                    Widgets.BundleImage(strum: symbol)
                        .pixelSize(Int(14 * appState.settings.theme.zoom))
                        .style(.svgIcon)
                        .halign(.center)
                case let .barLine(symbol):
                    Text(symbol.display)
                        .zoom(appState.settings.theme.zoom)
                        .style(.sectionGrid)
                        .halign(.center)
                case let .strumPattern(symbol):
                    Text(symbol.display)
                        .zoom(appState.settings.theme.zoom)
                        .style(.sectionGrid)
                        .halign(.center)
                case let .repeating(symbol):
                    Text(symbol.rawValue)
                        .zoom(appState.settings.theme.zoom)
                        .style(.sectionGrid)
                        .halign(.center)
                case .lyric:
                    // A grid has no lyrics, comment or textblock
                    Views.Empty()
                }
            }
            .halign(.center)
            .valign(.center)
            .padding(2, .horizontal)
        }
    }
}
