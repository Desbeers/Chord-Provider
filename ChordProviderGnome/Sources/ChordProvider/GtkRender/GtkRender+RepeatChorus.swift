//
//  GtkRender+RepeatChorus.swift
//  ChordProvider
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for repeating a chorus
    struct RepeatChorus: View {
        /// Init the `View`
        /// - Parameters:
        ///   - label: The optional label
        ///   - section: The current section
        ///   - appState: The state of the application
        init(label: String? = nil, section: Song.Section, appState: AppState) {
            self.label = label ?? section.label
            self.zoom = appState.settings.theme.zoom
        }
        /// The label of the section
        let label: String
        /// The zoom factor
        let zoom: Double
        /// The body of the `View`
        var view: Body {
            if !label.isEmpty {
                HStack(spacing: 10) {
                    Symbol(icon: .default(icon: .mediaPlaylistRepeat))
                        .pixelSize(Int(14 * zoom))
                    Text(label)
                        .zoom(zoom)
                }
                .style(.sectionRepeatChorus)
                .halign(.start)
                .padding()
            }
        }
    }
}
