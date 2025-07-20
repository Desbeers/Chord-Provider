//
//  RenderView+TextblockSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    struct TextblockSection: View {
        /// The section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// The alignment of the `VStack`
        let flush: HorizontalAlignment
        /// The multi-line alignment
        let textFlush: TextAlignment
        /// The frame alignment
        let alignment: Alignment
        /// Init the struct
        init(section: Song.Section, settings: AppSettings) {
            self.section = section
            self.settings = settings
            self.flush = getFlush(section.arguments)
            self.textFlush = getTextFlush(section.arguments)
            self.alignment = getAlign(section.arguments)
        }
        /// The body of the `View`
        var body: some View {
            VStack(alignment: flush, spacing: 0) {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine, .sourceComment:
                        /// Init the text like this to enable markdown formatting
                        Text(line.plain?.toMarkdown(fontOptions: settings.style.fonts.textblock, scale: settings.scale.magnifier) ?? "")
                    case .emptyLine:
                        EmptyLine(settings: settings)
                    case .comment:
                        CommentLabel(comment: line.plain, inline: true, settings: settings)
                    default:
                        EmptyView()
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(textFlush)
            .frame(
                idealWidth: settings.scale.maxSongLineWidth,
                maxWidth: settings.scale.maxSongLineWidth,
                alignment: alignment
            )
            .wrapSongSection(
                label: section.label,
                settings: settings
            )
        }
    }
}
