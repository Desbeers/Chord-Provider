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

    struct HeaderView: View {
        init(label: String? = nil, section: Song.Section, settings: AppSettings) {
            self.label = label ?? section.label
        }
        let label: String
        var view: Body {
            if !label.isEmpty {
                Text("<span size='large' weight='bold'>\(label)</span>")
                    .useMarkup()
                    .halign(.start)
                    .padding(10, .vertical)
                Separator()
            }
        }
    }
}
