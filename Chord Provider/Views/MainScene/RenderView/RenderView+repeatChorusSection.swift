//
//  RenderView+repeatChorusSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    /// SwiftUI `View` for a chorus repeat
    /// - Parameter section: The current ``Song/Section``
    /// - Returns: A `View` for the *{chorus..}* directive
    @ViewBuilder func repeatChorusSection(section: Song.Section) -> some View {
        if
            song.settings.shared.repeatWholeChorus,
            let lastChorus = song.sections.last(where: { $0.environment == .chorus && $0.label == section.label }) {
            /// Repeat the whole last chorus with the same label
            chorusSection(section: lastChorus)
        } else {
            /// Show a ``RenderView/ProminentLabel`` with an icon and the label
            ProminentLabel(
                label: section.label,
                font: song.settings.style.fonts.label.swiftUIFont(scale: song.settings.scale),
                settings: song.settings
            )
            .foregroundStyle(song.settings.style.fonts.label.color, song.settings.style.fonts.label.background)
            .frame(alignment: .leading)
            .wrapSongSection(
                settings: song.settings
            )
        }
    }
}
