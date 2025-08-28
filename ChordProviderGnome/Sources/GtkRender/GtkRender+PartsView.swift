//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    struct PartsView: View {
        let parts: [Song.Section.Line.Part]
        var view: Body {
                ForEach(parts, horizontal: true) { part in
                    VStack {
                        if let chord = part.chordDefinition {
                            Text("<span foreground='#0433ff'>\(chord.display)</span>")
                                .useMarkup()
                                .halign(.start)
                        } else {
                            Text(" ")
                        }
                        Text(.init("\(part.text ?? " ")"))
                            .halign(.start)
                    }
                }
            }
        }
}
