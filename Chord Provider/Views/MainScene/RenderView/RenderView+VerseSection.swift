//
//  RenderView+VerseSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

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
                        EmptyLine(settings: settings)
                    case .comment:
                        CommentLabel(comment: line.plain, inline: true, settings: settings)
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
