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
        let section: Song.Section
        let settings: AppSettings
        var view: Body {
            if !section.label.isEmpty {
                Text("<span size='large' weight='bold'>\(section.label)</span>")
                    .useMarkup()
                    .halign(.start)
                    .padding(10, .vertical)
                Separator()
            }
            }
        }
}
