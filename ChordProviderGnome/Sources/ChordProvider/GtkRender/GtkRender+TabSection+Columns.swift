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
                                column: column.columnID
                            )
                        }
                        .homogeneous()
                    }
                    .homogeneous()
                }
            }
            .padding(10)
        }

        private func event(event: Song.Section.Line.Tab.Event, column: Int) -> AnyView {
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
                            .style(column == currentPartID && playTabNotes ? .chordHighlight : .none)
                            .id(playTabNotes.description + currentPartID.description)
                        Text(filler)
                    }
                    .style(.tabButton)
                case let .transition(display, _, _, _):
                    Text(display)
                        .style(.tabButton)
                        .style(column == currentPartID && playTabNotes ? .chordHighlight : .none)
                        .id(playTabNotes.description + currentPartID.description)
                }
            }
            .style(.sectionTab)
            .halign(.center)
        }
    }
}
