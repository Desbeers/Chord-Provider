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
            if !section.label.isEmpty {
                Text(section.label)
                    .foregroundStyle(song.settings.style.fonts.label.color)
                    .font(song.settings.style.fonts.label.swiftUIFont(scale: song.settings.scale))
                Divider()
            }
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let parts = line.parts {
                        HStack(spacing: 0) {
                            ForEach(parts) { part in
                                if let chord = song.chords.first(where: { $0.id == part.chord }) {
                                    ChordView(settings: song.settings, sectionID: section.id, partID: part.id, chord: chord)
                                }
                                /// Init the text like this to enable markdown formatting
                                Text(.init(part.text))
                            }
                        }
                        .foregroundStyle(song.settings.style.fonts.textblock.color)
                        .font(song.settings.style.fonts.textblock.swiftUIFont(scale: song.settings.scale))
                    }
                case .comment:
                    Label(line.plain, systemImage: "text.bubble")
                        .font(song.settings.style.fonts.comment.swiftUIFont(scale: song.settings.scale))
                        .foregroundStyle(song.settings.style.fonts.comment.color)
                default:
                    EmptyView()
                }
            }
        }
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment(getTextFlush(section.arguments))
        .frame(minWidth: song.settings.maxWidth, idealWidth: song.settings.maxWidth, maxWidth: song.settings.maxWidth, alignment: getAlign(section.arguments))
        .wrapSongSection(
            settings: song.settings
        )
    }
}
