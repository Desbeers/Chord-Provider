//
//  GtkRender+SectionHeader.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a section header
    struct SectionHeader: View {
        /// Init the `View`
        init(label: String? = nil, section: Song.Section, settings: AppSettings) {
            self.label = label ?? section.label
            self.style = section.environment == .chorus ? .sectionChorus : .sectionHeader
        }
        /// The label of the header
        let label: String
        /// The style of the header
        let style: Markup.Class
        /// The body of the `View`
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
