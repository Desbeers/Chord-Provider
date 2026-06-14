//
//  GtkRender+TabSection+Lines.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import ChordProviderCore

extension GtkRender.TabSection {

    /// The `View` for lines of a tab section
    struct Lines: View {
        /// The lines of the tab
        let lines: [Song.Section.Line.Tab]
        /// Bool if the tab is playing with MIDI
        let playingTabNotes: Bool
        /// The column that is currently playing with MIDI 
        let currentColumnID: Int
        /// The zoom factor
        let zoom: Double
        /// The current accent color
        let color: (red: UInt16, green: UInt16, blue: UInt16)
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(lines) { line in
                    Text(line.plain)
                        .halign(.start)
                        .inspect { storage, _ in
                            line.highlight(
                                storage: storage,
                                color: color,
                                playingTabNotes: playingTabNotes,
                                currentColumnID: currentColumnID
                            )
                        }
                        .zoom(zoom)
                }
            }
            .style(.sectionTab)
            .padding(10)
        }
    }
}
