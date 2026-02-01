//
//  GtkRender+SectionHeader.swift
//  ChordProvider
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
        init(section: Song.Section, label: String? = nil) {
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
                    .padding(.vertical)
                Separator()
            }
        }
    }
}
