//
//  RenderView+textblockSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    // MARK: Textblock

    /// SwiftUI `View` for a plain text section
    func textblockSection(section: Song.Section) -> some View {
        VStack(alignment: getFlush(section.arguments)) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    /// Init the text like this to enable markdown formatting
                    Text(line.plain.toMarkdown(fontOptions: song.settings.style.fonts.textblock, scale: song.settings.scale))
                case .emptyLine:
                    Color.clear
                        .frame(height: song.settings.style.fonts.textblock.size)
                case .comment:
                    commentLabel(comment: line.plain)
                default:
                    EmptyView()
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment(getTextFlush(section.arguments))
        .frame(minWidth: song.settings.maxWidth, idealWidth: song.settings.maxWidth, maxWidth: song.settings.maxWidth, alignment: getAlign(section.arguments))
        .wrapSongSection(
            label: section.label,
            settings: song.settings
        )
    }
}
