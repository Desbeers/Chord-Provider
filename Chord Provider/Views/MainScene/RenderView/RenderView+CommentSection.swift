//
//  RenderView+CommentSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    // MARK: Comment


    struct CommentSection: View {
        /// The section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            CommentLabel(comment: section.lines.first?.plain ?? "", settings: settings)
                .wrapSongSection(
                    settings: settings
                )
        }
    }

    struct CommentLabel: View {

        let comment: String
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            RenderView.ProminentLabel(
                label: comment,
                sfSymbol: "text.bubble",
                font: settings.style.fonts.comment.swiftUIFont(scale: settings.scale.scale),
                settings: settings
            )
            .foregroundStyle(settings.style.fonts.comment.color, settings.style.fonts.comment.background)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
