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
