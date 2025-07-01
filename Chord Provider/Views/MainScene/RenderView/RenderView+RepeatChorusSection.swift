//
//  RenderView+RepeatChorusSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    struct RepeatChorusSection: View {
        /// The current section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// Init the struct
        init(section: Song.Section, sections: [Song.Section], settings: AppSettings) {
            self.settings = settings
            /// Check if we have to repeat the whole chorus
            if
                settings.shared.repeatWholeChorus,
                let lastChorus = sections.last(where: { $0.environment == .chorus && $0.label == section.label }) {
                /// Repeat the whole last chorus with the same label
                self.section = lastChorus
            } else {
                self.section = section
            }
        }
        /// The body of the `View`
        var body: some View {
            switch section.environment {
            case .repeatChorus:
                /// Show a ``RenderView/ProminentLabel`` with an icon and the label
                RenderView.ProminentLabel(
                    label: section.label,
                    sfSymbol: "arrow.trianglehead.2.clockwise.rotate.90",
                    font: settings.style.fonts.label.swiftUIFont(scale: settings.scale.scale),
                    settings: settings
                )
                .foregroundStyle(settings.style.fonts.label.color, settings.style.fonts.label.background)
                .frame(alignment: .leading)
                .wrapSongSection(
                    settings: settings
                )
            default:
                /// Repeat the whole last chorus
                ChorusSection(section: section, settings: settings)
            }
        }
    }
}
