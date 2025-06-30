//
//  RenderView+textblockSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView2 {

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
                    switch line.directive {
                    case .environmentLine, .sourceComment:
                        /// Init the text like this to enable markdown formatting
                        Text(line.plain?.toMarkdown(fontOptions: settings.style.fonts.textblock, scale: settings.scale) ?? "")
                    case .emptyLine:
                        Color.clear
                            .frame(height: settings.style.fonts.textblock.size / 2 * settings.scale)
                    case .comment:
                        CommentLabel(comment: line.plain ?? "", settings: settings)
                            .padding(.vertical, settings.style.fonts.text.size * settings.scale / 2)
                    default:
                        EmptyView()
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(textFlush)
            .frame(
                idealWidth: settings.maxWidth,
                maxWidth: settings.maxWidth,
                alignment: alignment
            )
            .wrapSongSection(
                label: section.label,
                settings: settings
            )
        }
    }
}

extension RenderView {

    // MARK: Textblock

    /// SwiftUI `View` for a plain text section
    func textblockSection(section: Song.Section) -> some View {
        VStack(alignment: getFlush(section.arguments), spacing: 0) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine, .sourceComment:
                    /// Init the text like this to enable markdown formatting
                    Text(line.plain?.toMarkdown(fontOptions: song.settings.style.fonts.textblock, scale: song.settings.scale) ?? "")
                case .emptyLine:
                    Color.clear
                        .frame(height: song.settings.style.fonts.textblock.size / 2 * song.settings.scale)
                case .comment:
                    commentLabel(comment: line.plain ?? "")
                        .padding(.vertical, song.settings.style.fonts.textblock.size * song.settings.scale / 2)
                default:
                    EmptyView()
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment(getTextFlush(section.arguments))
        .frame(
            idealWidth: song.settings.maxWidth,
            maxWidth: song.settings.maxWidth,
            alignment: getAlign(section.arguments)
        )
        .wrapSongSection(
            label: section.label,
            settings: song.settings
        )
    }
}
