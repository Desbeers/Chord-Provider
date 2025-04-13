//
//  RenderView+commentSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    // MARK: Comment

    /// SwiftUI `View` for a comment in its own section
    func commentSection(section: Song.Section) -> some View {
        commentLabel(comment: section.lines.first?.plain ?? "")
            .wrapSongSection(
                settings: song.settings
            )
    }

    /// SwiftUI `View` for a comment label
    @ViewBuilder func commentLabel(comment: String) -> some View {
        ProminentLabel(
            label: comment,
            sfIcon: "text.bubble",
            font: song.settings.style.fonts.comment.swiftUIFont(scale: song.settings.scale),
            settings: song.settings
        )
        .foregroundStyle(song.settings.style.fonts.comment.color, song.settings.style.fonts.comment.background)
        .fixedSize(horizontal: false, vertical: true)
    }
}
