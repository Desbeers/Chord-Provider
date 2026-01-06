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

    /// The `View` for repeating a chorus
    struct RepeatChorus: View {
        /// Init the `View`
        init(label: String? = nil, section: Song.Section) {
            self.label = label ?? section.label
        }
        /// The label of the section
        let label: String
        /// The body of the `View`
        var view: Body {
            if !label.isEmpty {
                HStack(spacing: 10) {
                    Symbol(icon: .default(icon: .mediaPlaylistRepeat))
                    Text(label)
                }
                .style(.repeatChorus)
                .halign(.start)
                .padding()
            }
        }
    }
}
