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

    struct PartsView: View {
        let parts: [Song.Section.Line.Part]
        let settings: AppSettings
        var view: Body {
            ForEach(parts, horizontal: true) { part in
                VStack {
                    if let chord = part.chordDefinition {
                        Text(chord.display, font: .chord, zoom: settings.app.zoom)
                            .useMarkup()
                            .halign(.start)
                    } else {
                        Text(" ", font: .standard, zoom: settings.app.zoom)
                            .useMarkup()
                    }
                    Text(part.text ?? " ", font: .standard, zoom: settings.app.zoom)
                        .useMarkup()
                        .halign(.start)
                }
            }
        }
    }
}
