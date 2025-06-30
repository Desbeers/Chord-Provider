//
//  RenderView+verseSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView2 {

    struct VerseSection: View {
        /// The section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(section.lines) { line in
                    switch line.directive {
                    case .environmentLine:
                        if let parts = line.parts {
                            PartsView(
                                parts: parts,
                                settings: settings
                            )
                        }
                    case .emptyLine:
                        Color.clear
                            .frame(height: settings.style.fonts.text.size * settings.scale)
                    case .comment:
                        CommentLabel(comment: line.plain ?? "", settings: settings)
                            .padding(.vertical, settings.style.fonts.text.size * settings.scale / 2)
                    default:
                        EmptyView()
                    }
                }
            }
            .wrapSongSection(
                label: section.label,
                settings: settings
            )
        }
    }
}

extension RenderView {

    // MARK: Verse

    /// SwiftUI `View` for a verse section
    func verseSection(section: Song.Section) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(section.lines) { line in
                switch line.directive {
                case .environmentLine:
                    if let parts = line.parts {
                        PartsView(
                            song: song,
                            parts: parts,
                            chords: song.chords
                        )
                    }
                case .emptyLine:
                    Color.clear
                        .frame(height: song.settings.style.fonts.text.size * song.settings.scale)
                case .comment:
                    commentLabel(comment: line.plain ?? "")
                        .padding(.vertical, song.settings.style.fonts.text.size * song.settings.scale / 2)
                default:
                    EmptyView()
                }
            }
        }
        .wrapSongSection(
            label: section.label,
            settings: song.settings
        )
    }
}
