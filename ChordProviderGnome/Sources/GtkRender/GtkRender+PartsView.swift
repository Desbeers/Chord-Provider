//
//  GtkRender+PartsView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for parts of a song lyric
    struct PartsView: View {
        /// The parts of the song line
        let parts: [Song.Section.Line.Part]
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            ForEach(parts, horizontal: true) { part in
                VStack {
                    if let chord = part.chordDefinition {
                        Text(part.withMarkup(chord))
                            .useMarkup()
                            .style(.chord)
                            .halign(.start)
                            .padding(5, .trailing)
                    } else {
                        Text(" ")
                            .style(.chord)
                    }
                    Text(part.lyricsText)
                        .useMarkup()
                        .style(.standard)
                        .halign(.start)
                }
            }
        }
    }
}
