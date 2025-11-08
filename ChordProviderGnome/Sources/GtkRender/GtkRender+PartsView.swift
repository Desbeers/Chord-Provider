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
        let parts: [Song.Section.Line.Part]
        let settings: AppSettings
        var view: Body {
            ForEach(parts, horizontal: true) { part in
                VStack {
                    if let chord = part.chordDefinition {
                        Text(chord.display)
                            .style(.chord)
                            .halign(.start)
                            .padding(5, .trailing)
                    } else {
                        Text(" ")
                            .style(.chord)
                    }
                    Text(part.text ?? " ")
                        .useMarkup()
                        .style(.standard)
                        .halign(.start)
                }
            }
        }
    }
}
