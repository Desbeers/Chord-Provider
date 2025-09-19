//
//  GtkRender+RepeatChorus.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    struct RepeatChorus: View {
        init(label: String? = nil, section: Song.Section, settings: AppSettings) {
            self.label = label ?? section.label
            self.settings = settings
        }
        let label: String
        let settings: AppSettings
        var view: Body {
            if !label.isEmpty {
                Text(label, font: .repeatChorus, zoom: settings.app.zoom)
                    .useMarkup()
                    .halign(.start)
                    .padding(10, .vertical)
            }
        }
    }
}
