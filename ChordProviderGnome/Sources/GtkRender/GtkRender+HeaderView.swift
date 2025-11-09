//
//  GtkRender+HeaderView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a header view
    struct HeaderView: View {
        init(label: String? = nil, section: Song.Section, settings: AppSettings) {
            self.label = label ?? section.label
            self.style = section.environment == .chorus ? .sectionChorus : .sectionHeader
        }
        let label: String
        let style: Markup.Class
        var view: Body {
            if !label.isEmpty {
                Text(label)
                    .style(style)
                    .halign(.start)
                    .padding(10, .vertical)
                Separator()
            }
        }
    }
}
