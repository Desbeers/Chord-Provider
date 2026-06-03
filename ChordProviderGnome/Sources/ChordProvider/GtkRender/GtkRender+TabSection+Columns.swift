//
//  GtkRender+TabSection+Columns.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender.TabSection {

    /// The `View` for columns of a tab section
    struct Columns: View {
        /// The columns of the grid
        let columns: [Song.Section.Line.Tab]
        /// The optional tempo
        let tempo: Int?
        /// Bool to play the tab with MIDI
        @Binding var playTabNotes: Bool
        /// The part that is currently playing with MIDI 
        @Binding var currentPartID: Int
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(columns, horizontal: true) { column in
                    Box {
                        ForEach(column.events, horizontal: false) { item in
                            event(
                                event: item,
                                columnID: column.columnID
                            )
                        }
                        .homogeneous()
                    }
                    .homogeneous()
                }
            }
            .padding(10)
        }

        /// The `View` for a tab event
        /// - Parameters:
        ///   - event: The tab event
        ///   - columnID: The ID of the colums
        /// - Returns: The event `View`
        private func event(event: Song.Section.Line.Tab.Event, columnID: Int) -> AnyView {
            Box {
                switch event.content {
                case .rest(let display):
                    Text(display)
                        .style(.dimmed)
                case .text(let text):
                    Text(text)
                        .halign(.start)
                case .barLine:
                    Text("|")
                case let .fret(display, _, filler):
                    HStack {
                        Text(display)
                            .style(columnID == currentPartID && playTabNotes ? .chordHighlight : .none)
                            .id(playTabNotes.description + currentPartID.description)
                        Text(filler)
                    }
                    .style(.tabButton)
                case let .transition(display, _, _, _):
                    Text(display)
                        .style(.tabButton)
                        .style(columnID == currentPartID && playTabNotes ? .chordHighlight : .none)
                        .id(playTabNotes.description + currentPartID.description)
                }
            }
            .style(.sectionTab)
            .halign(.center)
        }
    }
}
