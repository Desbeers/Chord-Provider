//
//  RenderView+CommentSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

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
        /// The comment
        let comment: String
        /// The padding of the comment
        var padding: Double = 0
        /// The settings for the song
        let settings: AppSettings
        /// Init the struct
        init(comment: String?, inline: Bool = false, settings: AppSettings) {
            self.comment = comment ?? "Empty Comment"
            self.settings = settings
            if inline {
                self.padding = settings.style.fonts.text.size * settings.scale.magnifier / 2
            }
        }
        /// The body of the `View`
        var body: some View {
            RenderView.ProminentLabel(
                label: comment,
                sfSymbol: "text.bubble",
                font: settings.style.fonts.comment.swiftUIFont(scale: settings.scale.magnifier),
                settings: settings
            )
            .foregroundStyle(settings.style.fonts.comment.color, settings.style.fonts.comment.background)
            .fixedSize(horizontal: false, vertical: true)
            .padding(padding)
        }
    }
}
