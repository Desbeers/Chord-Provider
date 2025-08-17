//
//  RenderView+LyricsSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension RenderView {

    struct LyricsSection: View {
        /// The section of the song
        let section: Song.Section
        /// The settings for the song
        let settings: AppSettings
        /// The body of the `View`
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
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
                prominent: section.environment == .chorus ? true : false,
                settings: settings
            )
        }
    }
}
